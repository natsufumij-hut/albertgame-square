class_name Ranks
extends Control

@export var textures :Array[Texture2D] = []

class UserScore:
	var userId: String
	var userAvatar: int
	var score: int
	func _init(user_id: String,user_avatar: int):
		userId=user_id
		userAvatar=user_avatar
		score=0

var user_score_arr: Array[UserScore] = []

func init_users(user_id_array: Array):
	user_score_arr.clear()
	for i in range(0,user_id_array.size()):
		var user_dict = user_id_array[i]
		var user_id = user_dict['userId'] as String
		var user_avatar = user_dict['avatar'] as String
		var user_score = UserScore.new(user_id,user_avatar.to_int())
		user_score_arr.append(user_score)
	rerender_ranks()

func rerender_ranks():
	for i in range(0,user_score_arr.size()):
		var user = user_score_arr[i]
		var node_path = "Avatar"+String.num((i+1))
		var node := get_node(node_path) as TextureRect
		var label := get_node(node_path+"/Label") as Label
		var texture = textures[user.userAvatar]
		node.texture = texture
		label.text = String.num(user.score)
		node.visible = true
	for i in range(user_score_arr.size(),6):
		var node_path = "Avatar"+String.num((i+1))
		var node := get_node(node_path) as TextureRect
		node.visible = false

func update_one_score(user_id: String, score: int):
	var one := user_score_arr.filter(func(user: UserScore): return user.userId==user_id ) as Array[UserScore]
	if one.is_empty() || one.size()!=1:
		return
	var dest = one[0]
	dest.score=score
	user_score_arr.sort_custom(sort_score_rank)
	rerender_ranks()
	
func sort_score_rank(user1:UserScore, user2:UserScore):
	return user1.score-user2.score
