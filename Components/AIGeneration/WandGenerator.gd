class_name WandGenerator extends Node

var _llama: GodotLlama;
var _worker: LlamaAsyncWorker;
var _model_path = "res://Assets/WandModel/model2.gguf";
var _context: String = "";
var _system_prompt: String = "";
var _rules_text : String = "";
var _output_text: String = "";
var _cached_state;
var _health_check: float = 0;
var _status_check: int = 0;

const MAX_TOKENS = 512;
const TEMP = 0.0;
const TOP_P = 1.0;
const MIN_P = 0.05;
const TOP_K = 40;
const REPEAT_PENALTY = 1.0;
const FREQUENCY_PENALTY = 0.0;
const PRESENCE_PENALTY = 0.0;
const PENALTY_LAST_N = 64;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Create Model & Context
	_llama = GodotLlama.new();
	_worker = LlamaAsyncWorker.new();
	var path = ProjectSettings.globalize_path(_model_path);
	
	var test := "Z:/PersonalProjects/CodeWizards/code-wizards/Assets/WandModel/model2.gguf"

	var f := FileAccess.open(test, FileAccess.READ)
	if f == null:
		push_error("Model Not Found.")
		return;
	
	_llama.load_model(path, {"n_gpu_layers": 99});
	
	var params := {
		"n_ctx": 16000,
		"n_batches": 1024,
		"threads": 4,
		"threads_batch": 4
	}
	
	_llama.create_context(params);
	_worker.context = _llama.context;
	_llama.context.generation_finished.connect(on_prompt_finish);
	
	# Set Rules
	set_rules_text();
	
func _process(delta: float) -> void:
	if _worker.is_busy():
		
		if _health_check > 1.0:
			print("busy");
			_health_check = 0;
			_status_check += 1;
		else:
			_health_check += delta;
			
		#if _status_check == 5:
			#print(_worker.get_latest_output());
			#_status_check = 0;
	
func set_rules_text():
	var files: = Array(DirAccess.get_files_at('res://Assets/WandRuleFiles/'));
	files.sort();
	
	for file in files:
		
		var path = 'res://Assets/WandRuleFiles/' + file
		_rules_text += FileAccess.get_file_as_string(path) + "\n\n";

func generate_wand(prompt_text) -> void:
	if not _llama.context.is_initialized():
		return

	_llama.context.clear_kv_cache()

	var prompt := _build_chat_prompt(_rules_text + prompt_text);
	var max_tokens := MAX_TOKENS
	
	# TODO modify the extension to allow for Async params.
	var params := {
		"temperature": TEMP,
		"top_p": TOP_P,
		"top_k": TOP_K,
		"min_p": MIN_P,
		"repeat_penalty": REPEAT_PENALTY,
		"frequency_penalty": FREQUENCY_PENALTY,
		"presence_penalty": PRESENCE_PENALTY,
		"penalty_last_n": PENALTY_LAST_N,
		"stop_sequences": ["<|im_end|>", "<|endoftext|>"]
	}

	_output_text = "";
	
	_worker.start_generation(prompt, max_tokens, params);
	#_llama.generate(prompt, max_tokens, params);
	print("Generation Started.");
	_health_check = 0;
	
	
func on_prompt_finish(result: String):
	var clean_result := _clean_assistant_output(result);
	_output_text = clean_result;
	
	var test_file = FileAccess.open("res://Tests/test.json", FileAccess.WRITE);
	test_file.store_string(_output_text);
	print(_output_text);
	
func _build_chat_prompt(user_text: String) -> String:
	var parts := PackedStringArray();
	var clean_system := _system_prompt.strip_edges();
	var context := _context.strip_edges();

	if not clean_system.is_empty():
		parts.append("<|im_start|>system");
		parts.append(clean_system);
		parts.append("<|im_end|>");
		
	if not context.is_empty():
		parts.append("<|im_start|>system");
		parts.append(context);
		parts.append("<|im_end|>");

	parts.append("<|im_start|>user");
	parts.append(user_text.strip_edges());
	parts.append("<|im_end|>");
	parts.append("<|im_start|>assistant");
	return "\n".join(parts);
	
func _clean_assistant_output(text: String) -> String:
	var out := text
	var end_idx := out.find("<|im_end");
	if end_idx >= 0:
		out = out.substr(0, end_idx);
	out = out.replace("<|im_start|>assistant", "");
	out = out.replace("<|im_start>assistant", "");
	out = out.replace("<|im_start|> assistant", "");
	out = out.replace("<|im_start> assistant", "");
	out = out.replace("<|im_start|>", "");
	out = out.replace("<|im_start>", "");
	out = out.replace("<|im_end|>", "");
	out = out.replace("<|im_end>", "");
	out = out.replace("<|endoftext|>", "");
	return out.strip_edges();
