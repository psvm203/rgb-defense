extends RefCounted

const WAVES: Array = [
	{
		groups = [
			{ max_rgb = Vector3(1.0, 0.0, 0.0), count = 5 },
			{ max_rgb = Vector3(0.0, 1.0, 0.0), count = 3 },
		],
		interval = 1.2,
		coins = 150,
	},
	{
		groups = [
			{ max_rgb = Vector3(0.0, 0.0, 1.0), count = 4 },
			{ max_rgb = Vector3(1.0, 0.0, 0.0), count = 2 },
		],
		interval = 1.0,
		coins = 175,
	},
	{
		groups = [
			{ max_rgb = Vector3(0.0, 1.0, 0.0), count = 4 },
			{ max_rgb = Vector3(0.0, 0.0, 1.0), count = 4 },
		],
		interval = 1.0,
		coins = 175,
	},
	{
		groups = [
			{ max_rgb = Vector3(1.0, 0.0, 0.0), count = 3 },
			{ max_rgb = Vector3(0.0, 1.0, 0.0), count = 3 },
			{ max_rgb = Vector3(0.0, 0.0, 1.0), count = 3 },
		],
		interval = 1.0,
		coins = 200,
	},
]
