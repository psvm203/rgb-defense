extends RefCounted

const STARTING_LIVES := 12

const STARTING_COINS := 800

const WAVES: Array = [
	{
		groups = [
			{ max_rgb = Vector3(300, 0, 0), count = 3 },
		],
		interval = 1.5,
	},
	{
		groups = [
			{ max_rgb = Vector3(0, 300, 0), count = 2 },
			{ max_rgb = Vector3(0, 0, 300), count = 2 },
		],
		interval = 1.4,
	},
	{
		groups = [
			{ max_rgb = Vector3(400, 400, 400), count = 2 },
		],
		interval = 1.5,
	},
	{
		groups = [
			{ max_rgb = Vector3(300, 0, 300), count = 3 },
			{ max_rgb = Vector3(300, 300, 0), count = 2 },
		],
		interval = 1.3,
	},
	{
		groups = [
			{ max_rgb = Vector3(500, 500, 500), count = 3 },
		],
		interval = 1.2,
	},
]
