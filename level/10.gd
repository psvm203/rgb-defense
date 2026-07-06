extends RefCounted

const STARTING_LIVES := 5

const STARTING_COINS := 1200

const WAVES: Array = [
	{
		groups = [
			{ max_rgb = Vector3(100, 0, 0), count = 6 },
			{ max_rgb = Vector3(0, 100, 0), count = 6 },
			{ max_rgb = Vector3(0, 0, 100), count = 6 },
		],
		interval = 0.7,
	},
	{
		groups = [
			{ max_rgb = Vector3(100, 100, 100), count = 8 },
		],
		interval = 0.7,
	},
	{
		groups = [
			{ max_rgb = Vector3(150, 0, 0), count = 5 },
			{ max_rgb = Vector3(150, 0, 150), count = 4 },
		],
		interval = 0.6,
	},
	{
		groups = [
			{ max_rgb = Vector3(0, 150, 0), count = 5 },
			{ max_rgb = Vector3(150, 150, 0), count = 4 },
		],
		interval = 0.6,
	},
	{
		groups = [
			{ max_rgb = Vector3(0, 0, 150), count = 5 },
			{ max_rgb = Vector3(0, 150, 150), count = 4 },
		],
		interval = 0.6,
	},
	{
		groups = [
			{ max_rgb = Vector3(200, 200, 200), count = 4 },
			{ max_rgb = Vector3(150, 0, 150), count = 3 },
			{ max_rgb = Vector3(150, 150, 0), count = 3 },
		],
		interval = 0.5,
	},
	{
		groups = [
			{ max_rgb = Vector3(250, 0, 0), count = 4 },
			{ max_rgb = Vector3(0, 250, 0), count = 4 },
			{ max_rgb = Vector3(0, 0, 250), count = 4 },
		],
		interval = 0.5,
	},
	{
		groups = [
			{ max_rgb = Vector3(300, 300, 300), count = 6 },
		],
		interval = 0.4,
	},
]
