extends Control


func _on_capture_contract_pressed():
	GameManager.currentContract = GameManager.ContractData.new($MarginContainer/HBoxContainer/CaptureContract)
	get_tree().change_scene_to_file("res://src/main.tscn")


func _on_defend_contract_pressed():
	GameManager.currentContract = GameManager.ContractData.new($MarginContainer/HBoxContainer/DefendContract)
	get_tree().change_scene_to_file("res://src/main.tscn")


func _on_route_contract_pressed():
	GameManager.currentContract = GameManager.ContractData.new($MarginContainer/HBoxContainer/RouteContract)
	get_tree().change_scene_to_file("res://src/main.tscn")

