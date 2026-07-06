extends RefCounted

const STARTING_LIVES := 12

const STARTING_COINS := 1000

const WAVES: Array = [
	{
		groups = [
			{ max_rgb = Vector3(120, 0, 0), count = 8 },
			{ max_rgb = Vector3(0, 120, 0), count = 6 },
		],
		interval = 1.0,
	},
	{
		groups = [
			{ max_rgb = Vector3(0, 0, 120), count = 6 },
			{ max_rgb = Vector3(120, 0, 120), count = 4 },
		],
		interval = 0.9,
	},
	{
		groups = [
			{ max_rgb = Vector3(120, 120, 0), count = 5 },
			{ max_rgb = Vector3(0, 120, 120), count = 5 },
		],
		interval = 0.9,
	},
	{
		groups = [
			{ max_rgb = Vector3(180, 180, 180), count = 4 },
		],
		interval = 1.0,
	},
	{
		groups = [
			{ max_rgb = Vector3(150, 0, 0), count = 6 },
			{ max_rgb = Vector3(0, 150, 0), count = 6 },
			{ max_rgb = Vector3(0, 0, 150), count = 6 },
		],
		interval = 0.8,
	},
	{
		groups = [
			{ max_rgb = Vector3(180, 0, 180), count = 5 },
			{ max_rgb = Vector3(180, 180, 0), count = 5 },
		],
		interval = 0.8,
	},
	{
		groups = [
			{ max_rgb = Vector3(150, 150, 150), count = 5 },
			{ max_rgb = Vector3(0, 150, 150), count = 4 },
		],
		interval = 0.7,
	},
	{
		groups = [
			{ max_rgb = Vector3(250, 250, 250), count = 5 },
		],
		interval = 0.7,
	},
]
