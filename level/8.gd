extends RefCounted

const STARTING_LIVES := 8

const STARTING_COINS := 900

const WAVES: Array = [
	{
		groups = [
			{ max_rgb = Vector3(100, 0, 0), count = 6 },
			{ max_rgb = Vector3(0, 100, 100), count = 4 },
		],
		interval = 0.8,
	},
	{
		groups = [
			{ max_rgb = Vector3(0, 100, 0), count = 6 },
			{ max_rgb = Vector3(100, 0, 100), count = 4 },
		],
		interval = 0.7,
	},
	{
		groups = [
			{ max_rgb = Vector3(0, 0, 100), count = 6 },
			{ max_rgb = Vector3(100, 100, 0), count = 4 },
		],
		interval = 0.7,
	},
	{
		groups = [
			{ max_rgb = Vector3(100, 100, 100), count = 8 },
		],
		interval = 0.6,
	},
	{
		groups = [
			{ max_rgb = Vector3(100, 0, 100), count = 5 },
			{ max_rgb = Vector3(100, 100, 0), count = 5 },
			{ max_rgb = Vector3(0, 100, 100), count = 5 },
		],
		interval = 0.6,
	},
	{
		groups = [
			{ max_rgb = Vector3(100, 0, 0), count = 5 },
			{ max_rgb = Vector3(0, 100, 0), count = 5 },
			{ max_rgb = Vector3(0, 0, 100), count = 5 },
		],
		interval = 0.5,
	},
	{
		groups = [
			{ max_rgb = Vector3(150, 150, 150), count = 6 },
		],
		interval = 0.5,
	},
]
