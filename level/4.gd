extends RefCounted

const STARTING_LIVES := 10

const STARTING_COINS := 500

const WAVES: Array = [
	{
		groups = [
			{ max_rgb = Vector3(100, 0, 100), count = 5 },
		],
		interval = 1.2,
	},
	{
		groups = [
			{ max_rgb = Vector3(100, 100, 0), count = 6 },
		],
		interval = 1.1,
	},
	{
		groups = [
			{ max_rgb = Vector3(0, 100, 100), count = 5 },
		],
		interval = 1.1,
	},
	{
		groups = [
			{ max_rgb = Vector3(100, 0, 100), count = 4 },
			{ max_rgb = Vector3(100, 100, 0), count = 3 },
		],
		interval = 1.0,
	},
	{
		groups = [
			{ max_rgb = Vector3(100, 100, 100), count = 3 },
			{ max_rgb = Vector3(0, 100, 100), count = 3 },
		],
		interval = 0.9,
	},
	{
		groups = [
			{ max_rgb = Vector3(100, 0, 100), count = 3 },
			{ max_rgb = Vector3(100, 100, 0), count = 3 },
			{ max_rgb = Vector3(0, 100, 100), count = 4 },
		],
		interval = 0.8,
	},
]
