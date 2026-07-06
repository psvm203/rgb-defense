extends RefCounted

const STARTING_LIVES := 10

const STARTING_COINS := 250

const WAVES: Array = [
	{
		groups = [
			{ max_rgb = Vector3(100, 0, 0), count = 5 },
			{ max_rgb = Vector3(0, 100, 0), count = 3 },
		],
		interval = 1.2,
	},
	{
		groups = [
			{ max_rgb = Vector3(0, 0, 100), count = 4 },
			{ max_rgb = Vector3(100, 0, 0), count = 2 },
		],
		interval = 1.0,
	},
	{
		groups = [
			{ max_rgb = Vector3(0, 100, 0), count = 4 },
			{ max_rgb = Vector3(0, 0, 100), count = 4 },
		],
		interval = 1.0,
	},
	{
		groups = [
			{ max_rgb = Vector3(100, 0, 0), count = 3 },
			{ max_rgb = Vector3(0, 100, 0), count = 3 },
			{ max_rgb = Vector3(0, 0, 100), count = 3 },
		],
		interval = 1.0,
	},
]
