extends RefCounted

const STARTING_LIVES := 5

const STARTING_COINS := 50

const WAVES: Array = [
	{
		groups = [
			{ max_rgb = Vector3(100, 0, 0), count = 3 },
		],
		interval = 1.5,
	},
	{
		groups = [
			{ max_rgb = Vector3(100, 0, 0), count = 5 },
		],
		interval = 1.2,
	},
	{
		groups = [
			{ max_rgb = Vector3(100, 0, 0), count = 7 },
		],
		interval = 1.0,
	},
]
