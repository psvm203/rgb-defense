extends RefCounted

const STARTING_LIVES := 10000

const STARTING_COINS := 10000

const WAVES: Array = [
	{
		groups = [
			{ max_rgb = Vector3(100, 0, 0), count = 2 },
			{ max_rgb = Vector3(0, 100, 0), count = 2 },
			{ max_rgb = Vector3(0, 0, 100), count = 2 },
		],
		interval = 1.5,
	},
]
