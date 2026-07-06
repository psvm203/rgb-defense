extends RefCounted

const STARTING_LIVES := 10

const STARTING_COINS := 400

const WAVES: Array = [
	{
		groups = [
			{ max_rgb = Vector3(100, 0, 0), count = 6 },
			{ max_rgb = Vector3(0, 100, 0), count = 4 },
		],
		interval = 1.2,
	},
	{
		groups = [
			{ max_rgb = Vector3(0, 0, 100), count = 5 },
			{ max_rgb = Vector3(0, 100, 0), count = 5 },
		],
		interval = 1.0,
	},
	{
		groups = [
			{ max_rgb = Vector3(100, 0, 0), count = 4 },
			{ max_rgb = Vector3(0, 100, 0), count = 4 },
			{ max_rgb = Vector3(0, 0, 100), count = 4 },
		],
		interval = 1.0,
	},
	{
		groups = [
			{ max_rgb = Vector3(0, 0, 100), count = 6 },
			{ max_rgb = Vector3(100, 0, 0), count = 4 },
		],
		interval = 0.9,
	},
	{
		groups = [
			{ max_rgb = Vector3(100, 0, 0), count = 5 },
			{ max_rgb = Vector3(0, 100, 0), count = 5 },
			{ max_rgb = Vector3(0, 0, 100), count = 5 },
		],
		interval = 0.8,
	},
]
