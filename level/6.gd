extends RefCounted

const STARTING_LIVES := 10

const STARTING_COINS := 700

const WAVES: Array = [
	{
		groups = [
			{ max_rgb = Vector3(60, 0, 0), count = 12 },
		],
		interval = 0.8,
	},
	{
		groups = [
			{ max_rgb = Vector3(0, 60, 0), count = 10 },
			{ max_rgb = Vector3(0, 0, 60), count = 10 },
		],
		interval = 0.7,
	},
	{
		groups = [
			{ max_rgb = Vector3(60, 60, 0), count = 12 },
		],
		interval = 0.8,
	},
	{
		groups = [
			{ max_rgb = Vector3(60, 0, 60), count = 8 },
			{ max_rgb = Vector3(0, 60, 60), count = 8 },
		],
		interval = 0.7,
	},
	{
		groups = [
			{ max_rgb = Vector3(60, 0, 0), count = 8 },
			{ max_rgb = Vector3(0, 60, 0), count = 8 },
			{ max_rgb = Vector3(0, 0, 60), count = 8 },
		],
		interval = 0.6,
	},
	{
		groups = [
			{ max_rgb = Vector3(60, 60, 60), count = 15 },
		],
		interval = 0.6,
	},
]
