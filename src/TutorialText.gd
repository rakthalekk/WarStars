extends TextureRect

var first_text = "Welcome to Nexus Conquest! your goal is to defeat the enemy forces using your army of summoned soldiers.

You can move your cursor using the WASD keys and select a unit to control using SPACE."

var second_text = "You can move a unit to the position of the cursor after selecting using SPACE. A unit may attack or wait after moving. They may also use an item if any are available. Waiting will reduce damage from attacks by 50%."

var third_text = "Each unit has 1-2 weapons and 0-2 items. Each type of weapon has different attack ranges and damage values. They also build heat over time (except melee) and will become overheated with repeated use."

var fourth_text = "Press 1-4 while hovering over an enemy to see information about its weapons and items.

You can also cancel an action using the TAB key while a unit is selected."

var fifth_text = "The darker red squares on the map indicate the danger area where enemies can attack. Individual enemies can be highlighted by selecting them with space to see their move and attack range. one enemy can be highighted at a time."

var sixth_text = "Some types of terrain have different effects. Rocks and water block movement. Thorns deal damage after your turn. Acid Pools build heat after your turn.
Units standing in tall grass can only be attacked from 1 space away."

var seventh_text = "Your first objective is to defeat all enemy troops. If you succeed you will return to the fleet and can summon more troops to join your army.

Good luck soldier! (Reopen help with H)"

var texts = [first_text, second_text, third_text, fourth_text, fifth_text, sixth_text, seventh_text]

var text_idx = 0

func _ready():
	$Label.text = first_text


func update_text():
	$Previous.show()
	$Next.show()
	$Label.text = texts[text_idx]
	
	if text_idx == 0:
		$Previous.hide()
	if text_idx == texts.size() - 1:
		$Next.hide()


func _on_next_pressed():
	text_idx += 1
	update_text()


func _on_previous_pressed():
	text_idx -= 1
	update_text()


func _on_close_pressed():
	hide()
