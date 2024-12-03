# Finite Automaton Reader and Visualizer

def parse_fa_file(file_name):
    """Parses the finite automaton description from a file."""
    with open(file_name, 'r') as file:
        data = file.readlines()

    fa = {
        "states": set(),
        "alphabet": set(),
        "transitions": [],
        "start_state": None,
        "final_states": set()
    }

    # Parsing the file line by line
    for line in data:
        line = line.strip()
        if line.startswith("states:"):
            fa["states"] = set(line.split(":")[1].strip().split(","))
        elif line.startswith("alphabet:"):
            fa["alphabet"] = set(line.split(":")[1].strip().split(","))
        elif "->" in line:
            # Format: q0, a -> q1
            parts = line.split("->")
            lhs = parts[0].strip()
            current_state, input_symbol = [x.strip() for x in lhs.split(",")]
            next_state = parts[1].strip()
            fa["transitions"].append((current_state, input_symbol, next_state))
        elif line.startswith("start:"):
            fa["start_state"] = line.split(":")[1].strip()
        elif line.startswith("final:"):
            fa["final_states"] = set(line.split(":")[1].strip().split(","))

    return fa


def display_fa(fa):
    """Displays the finite automaton components."""
    print("Finite Automaton Components:")
    print(f"States: {fa['states']}")
    print(f"Alphabet: {fa['alphabet']}")
    print(f"Start State: {fa['start_state']}")
    print(f"Final States: {fa['final_states']}")
    print("Transitions:")
    for transition in fa["transitions"]:
        print(f"  {transition[0]} --({transition[1]})--> {transition[2]}")


# Main Program
if __name__ == "__main__":
    file_name = "FA.in"
    fa = parse_fa_file(file_name)
    display_fa(fa)
