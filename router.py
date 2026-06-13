from enum import Enum

class Intent(str, Enum):
    FAST='FAST'
    REASONING='REASONING'
    TOOL='TOOL'

def classify(text: str) -> Intent:
    t=text.lower()
    if any(x in t for x in ['api','search','file']):
        return Intent.TOOL
    if any(x in t for x in ['why','analyze','plan','design']):
        return Intent.REASONING
    return Intent.FAST

def select_model(intent: Intent) -> str:
    return {
        Intent.FAST:'meta/llama-3.1-8b-instruct',
        Intent.REASONING:'meta/llama-3.1-70b-instruct',
        Intent.TOOL:'microsoft/phi-4-mini-reasoning'
    }[intent]
