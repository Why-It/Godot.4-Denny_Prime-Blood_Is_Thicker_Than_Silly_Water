extends CanvasLayer

var cur_ammo_gui : int = 69
var cur_reserve_gui : int = 420

@onready var cur_ammo_display : Node = $MarginContainer/Rows/BottomRow/Right/Ammo/CurrentAmmo
@onready var cur_reserve_display : Node = $MarginContainer/Rows/BottomRow/Right/Ammo/ReserveAmmo


# Called when the node enters the scene tree for the first time.
func _ready():
	if cur_ammo_display == null:
		print("fuck")
	if cur_reserve_display == null:
		print("goddamnit")
	UpdateAmmoDetails()
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func UpdateAmmoDetails():
	cur_ammo_display.set("text", str(cur_ammo_gui))
	cur_reserve_display.set("text", str(cur_reserve_gui))
	
