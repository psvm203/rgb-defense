extends RefCounted

const STARTING_LIVES := 10

const STARTING_COINS := 600

const WAVES: Array = [
	{
		groups = [
			{ max_rgb = Vector3(150, 0, 0), count = 8 },
		],
		interval = 1.2,
	},
	{
		groups = [
			{ max_rgb = Vector3(0, 150, 0), count = 6 },
			{ max_rgb = Vector3(0, 0, 150), count = 4 },
		],
		interval = 1.0,
	},
	{
		groups = [
			{ max_rgb = Vector3(150, 0, 150), count = 5 },
		],
		interval = 1.1,
	},
	{
		groups = [
			{ max_rgb = Vector3(150, 150, 0), count = 4 },
			{ max_rgb = Vector3(0, 150, 150), count = 4 },
		],
		interval = 1.0,
	},
	{
		groups = [
			{ max_rgb = Vector3(150, 0, 0), count = 6 },
			{ max_rgb = Vector3(0, 150, 0), count = 6 },
			{ max_rgb = Vector3(0, 0, 150), count = 6 },
		],
		interval = 0.9,
	},
	{
		groups = [
			{ max_rgb = Vector3(200, 200, 200), count = 4 },
		],
		interval = 0.8,
	},
]
