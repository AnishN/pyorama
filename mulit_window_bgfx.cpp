#define MAX_WINDOWS 8

void init(int32_t _argc, const char* const* _argv, uint32_t _width, uint32_t _height) override
{
	Args args(_argc, _argv);

	m_width  = _width;
	m_height = _height;
	m_debug  = BGFX_DEBUG_TEXT;
	m_reset  = BGFX_RESET_VSYNC;

	bgfx::Init init;
	init.type     = args.m_type;
	init.vendorId = args.m_pciId;
	init.resolution.width  = m_width;
	init.resolution.height = m_height;
	init.resolution.reset  = m_reset;
	bgfx::init(init);

	bgfx::setDebug(m_debug);
	bgfx::setViewClear(0, BGFX_CLEAR_COLOR|BGFX_CLEAR_DEPTH, 0x303030ff, 1.0f, 0);
	bx::memSet(m_fbh, 0xff, sizeof(m_fbh) );

virtual int shutdown() override
	for (uint32_t ii = 0; ii < MAX_WINDOWS; ++ii)
		if (bgfx::isValid(m_fbh[ii]) )
			bgfx::destroy(m_fbh[ii]);
	bgfx::destroy(m_ibh);
	bgfx::destroy(m_vbh);
	bgfx::destroy(m_program);
	bgfx::shutdown();
	return 0;

bool update() override
	if (!entry::processWindowEvents(m_state, m_debug, m_reset) )
		entry::MouseState mouseState = m_state.m_mouse;
		if (isValid(m_state.m_handle) )
			if (0 == m_state.m_handle.idx)
				m_width  = m_state.m_width;
				m_height = m_state.m_height;
			else
				uint8_t viewId = (uint8_t)m_state.m_handle.idx;
				entry::WindowState& win = m_windows[viewId];
				if (win.m_nwh    != m_state.m_nwh
				|| (win.m_width  != m_state.m_width
				||  win.m_height != m_state.m_height) )
					if (bgfx::isValid(m_fbh[viewId]) )
						bgfx::destroy(m_fbh[viewId]);
						m_fbh[viewId].idx = bgfx::kInvalidHandle;
					win.m_nwh    = m_state.m_nwh;
					win.m_width  = m_state.m_width;
					win.m_height = m_state.m_height;
					if (NULL != win.m_nwh)
						m_fbh[viewId] = bgfx::createFrameBuffer(win.m_nwh, uint16_t(win.m_width), uint16_t(win.m_height) );
					else
						win.m_handle.idx = UINT16_MAX;

		const bx::Vec3 at  = { 0.0f, 0.0f,   0.0f };
		const bx::Vec3 eye = { 0.0f, 0.0f, -35.0f };
		float view[16];
		bx::mtxLookAt(view, eye, at);
		float proj[16];
		bx::mtxProj(proj, 60.0f, float(m_width)/float(m_height), 0.1f, 100.0f, bgfx::getCaps()->homogeneousDepth);
		bgfx::setViewTransform(0, view, proj);
		bgfx::setViewRect(0, 0, 0, uint16_t(m_width), uint16_t(m_height) );
		bgfx::touch(0);

		for (uint8_t ii = 1; ii < MAX_WINDOWS; ++ii)
			bgfx::setViewTransform(ii, view, proj);
			bgfx::setViewFrameBuffer(ii, m_fbh[ii]);
			if (!bgfx::isValid(m_fbh[ii]) )
				bgfx::setViewRect(ii, 0, 0, uint16_t(m_width), uint16_t(m_height) );
				bgfx::setViewClear(ii, BGFX_CLEAR_NONE);
			else
				bgfx::setViewRect(ii, 0, 0, uint16_t(m_windows[ii].m_width), uint16_t(m_windows[ii].m_height) );
				bgfx::setViewClear(ii
					, BGFX_CLEAR_COLOR|BGFX_CLEAR_DEPTH
					, 0x303030ff
					, 1.0f
					, 0
					);
		uint32_t count = 0;
		for (uint32_t yy = 0; yy < 11; ++yy)
			for (uint32_t xx = 0; xx < 11; ++xx)
				float mtx[16];
				bx::mtxRotateXY(mtx, time + xx*0.21f, time + yy*0.37f);
				mtx[12] = -15.0f + float(xx)*3.0f;
				mtx[13] = -15.0f + float(yy)*3.0f;
				mtx[14] = 0.0f;
				bgfx::setTransform(mtx);
				bgfx::setVertexBuffer(0, m_vbh);
				bgfx::setIndexBuffer(m_ibh);
				bgfx::setState(BGFX_STATE_DEFAULT);
				bgfx::submit(count%MAX_WINDOWS, m_program);
				++count;
		bgfx::frame();
		return true;
	return false;

void createWindow()
	entry::WindowHandle handle = entry::createWindow(rand()%1280, rand()%720, 640, 480);
	if (entry::isValid(handle) )
		char str[256];
		bx::snprintf(str, BX_COUNTOF(str), "Window - handle %d", handle.idx);
		entry::setWindowTitle(handle, str);
		m_windows[handle.idx].m_handle = handle;

void destroyWindow()
	for (uint32_t ii = 0; ii < MAX_WINDOWS; ++ii)
		if (bgfx::isValid(m_fbh[ii]) )
			bgfx::destroy(m_fbh[ii]);
			m_fbh[ii].idx = bgfx::kInvalidHandle;
			bgfx::frame();
			bgfx::frame();
		if (entry::isValid(m_windows[ii].m_handle) )
			entry::destroyWindow(m_windows[ii].m_handle);
			m_windows[ii].m_handle.idx = UINT16_MAX;
			return;

entry::WindowState m_state;
uint32_t m_width;
uint32_t m_height;
uint32_t m_debug;
uint32_t m_reset;
bgfx::VertexBufferHandle m_vbh;
bgfx::IndexBufferHandle m_ibh;
bgfx::ProgramHandle m_program;
entry::WindowState m_windows[MAX_WINDOWS];
bgfx::FrameBufferHandle m_fbh[MAX_WINDOWS];
int64_t m_timeOffset;