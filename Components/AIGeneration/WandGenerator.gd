class_name WandGenerator extends Node


var _llama: GodotLlama;

const MAX_TOKENS = 2048;
const TEMP = 0.7;
const TOP_P = 0.9;
const MIN_P = 0.1;
const TOP_K = 40;
const REPEAT_PENALTY = 1.1;
const FREQUENCY_PENALTY = 1.0;
const PRESENCE_PENALTY = 1.0;
const PENALTY_LAST_N = 64;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_llama = GodotLlama.new();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

static func generate_wand() -> void:
    if not _llama.context.is_initialized():
        _set_status("create context first")
        return

    var user_text := _prompt_edit.text.strip_edges()
    if user_text.is_empty():
        _set_status("prompt is empty")
        return

    # The demo rebuilds the full conversation prompt each turn, so reset context first.
    _llama.context.reset()

    var prompt := _build_chat_prompt(user_text)
    var max_tokens := MAX_TOKENS
    var params := {
        "temperature": TEMP,
        "top_p": TOP_P,
        "top_k": TOP_K,
        "min_p": MIN_P,
        "repeat_penalty": REPEAT_PENALTY,
        "frequency_penalty": FREQUENCY_PENALTY,
        "presence_penalty": PRESENCE_PENALTY,
        "penalty_last_n": PENALTY_LAST_N,
    }

    var stop_sequences := _parse_stop_sequences(_stop_sequences_edit.text)
    if not stop_sequences.is_empty():
        params["stop_sequences"] = stop_sequences

    _output_text.clear()

    _set_status("generating...")
    var result := _llama.generate(prompt, max_tokens, params)
    var clean_result := _clean_assistant_output(result)
    _output_text.text = clean_result
    _append_chat_turn("user", user_text)
    _append_chat_turn("assistant", clean_result)
    _set_status("generation finished")
