import numpy as np
from pyorama.core.item_hash_map cimport *
from pyorama.core.item_vector cimport *
from pyorama.libs.c cimport *
from pyorama.math3d cimport *

cdef object UNSUPPORTED_KEYWORD_ERROR = ValueError(b"OBJLoader: unsupported keyword in file")

ctypedef struct OBJIndexC:
    uint32_t position
    uint32_t tex_coord
    uint32_t normal

ctypedef struct OBJVertexC:
    Vec3C position
    Vec2C tex_coord
    Vec3C normal

cdef class OBJLoader:
    
    @staticmethod
    def load_file(bytes file_name):
        cdef:
            list lines
            bytes line
            size_t i, j
            size_t num_lines
            list values
            list face_vertices
            size_t num_face_vertices
            ItemVector positions = ItemVector(sizeof(Vec3C))
            ItemVector tex_coords = ItemVector(sizeof(Vec2C))
            ItemVector normals = ItemVector(sizeof(Vec3C))
            list b_indices = []
            bytes b_index
            size_t num_indices
            Vec3C p
            Vec2C t
            Vec3C n
            OBJIndexC ptn

        in_file = open(file_name, "rb")
        lines = in_file.readlines()
        in_file.close()
        
        num_lines = len(lines)
        for i in range(num_lines):
            line = <bytes>lines[i]
            values = <list>line.split()
            if values == []:
                pass#empty line
            elif values[0].startswith(b"#"):
                pass
            elif values[0] == b"v":
                p[0] = atof(<bytes>values[1])
                p[1] = atof(<bytes>values[2])
                p[2] = atof(<bytes>values[3])
                positions.c_push(&p)
            elif values[0] == b"vt":
                t[0] = atof(<bytes>values[1])
                t[1] = atof(<bytes>values[2])
                tex_coords.c_push(&t)
            elif values[0] == b"vn":
                n[0] = atof(<bytes>values[1])
                n[1] = atof(<bytes>values[2])
                n[2] = atof(<bytes>values[3])
                normals.c_push(&n)
            elif values[0] == b"f":
                num_face_vertices = len(values) - 1
                if num_face_vertices < 3:
                    raise ValueError("OBJLoader: invalid vertices count per face < 3")
                elif num_face_vertices == 3:
                    b_indices.extend(values[1:])
                else:# parse as triangle fan
                    for j in range(2, num_face_vertices):
                        b_indices.append(values[1])
                        b_indices.append(values[j])
                        b_indices.append(values[j + 1])
            elif values[0] == b"o":
                pass# TODO: fix object and group handling
            elif values[0] == b"g":
                pass
            elif values[0] == b"s":#smoothing group
                pass
            elif values[0] == b"mtllib":
                pass
            elif values[0] == b"usemtl":
                pass
            else:
                print(values)
                raise UNSUPPORTED_KEYWORD_ERROR
        
        cdef:
            uint32_t combined_index = 0
            uint32_t next_combined_index = 0
            #OBJIndexC index
            OBJVertexC vertex
            tuple t_index
            dict index_map = {}
            list b_parts
            size_t num_parts
            bytes b_part
            int part
            bint index_text
            ItemVector vertex_data = ItemVector(sizeof(OBJVertexC))
            ItemVector index_data = ItemVector(sizeof(uint32_t))
            float[:] v_arr
            uint32_t[:] i_arr

        num_indices = len(b_indices)
        for i in range(num_indices):
            b_index = <bytes>b_indices[i]
            t_index = OBJLoader.parse_triple(b_index)
            #print(i, b_index, t_index)
            index_test = t_index in index_map
            if index_test:
                combined_index = index_map[t_index]
            else:
                combined_index = next_combined_index
                index_map[t_index] = combined_index
                next_combined_index += 1
                positions.c_get(t_index[0], &vertex.position)
                #print(i, b_index, t_index)
                if 0 <= t_index[1] < tex_coords.num_items:
                    tex_coords.c_get(t_index[1], &vertex.tex_coord)
                else:
                    vertex.tex_coord[0] = 0.0
                    vertex.tex_coord[1] = 0.0
                if 0 <= t_index[2] < normals.num_items:
                    normals.c_get(t_index[2], &vertex.normal)
                else:
                    vertex.normal[0] = 0.0
                    vertex.normal[1] = 0.0
                    vertex.normal[2] = 0.0
                vertex_data.c_push(&vertex)
            index_data.c_push(&combined_index)
        
        v_arr = <float[:vertex_data.num_items * 8]>(<float *>vertex_data.items)
        i_arr = <uint32_t[:index_data.num_items]>(<uint32_t *>index_data.items)
        return v_arr, i_arr
    
    @staticmethod
    cdef tuple parse_triple(bytes triple):
        cdef:
            list parts
            size_t i
            size_t num_parts
            bytes b_part
            int part
            int part_2
            tuple out
            list new_parts = []

        parts = <list>triple.split(b"/")
        num_parts = len(parts)
        if num_parts == 0 or num_parts > 3:
            raise ValueError("OBJLoader: invalid vertex index format")
        elif num_parts == 1:
            b_part = <bytes>parts[0]
            part = atoi(b_part) - 1
            out = (part, part, part)
            return out
        elif num_parts == 2:
            b_part = <bytes>parts[0]
            part = atoi(b_part) - 1
            b_part = <bytes>parts[1]
            part_2 = atoi(b_part) - 1
            out = (part, part_2, part)
            return out
        else:
            for i in range(num_parts):
                b_part = <bytes>parts[i]
                part = atoi(b_part) - 1
                new_parts.append(part)
            out = tuple(new_parts)
            return out