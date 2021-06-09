#include <vector>
#include <unordered_set>

#include <iostream>

constexpr unsigned floorlog2(unsigned x)
{
    return x == 1 ? 0 : 1+floorlog2(x >> 1);
}

constexpr unsigned ceillog2(unsigned x)
{
    return x == 1 ? 0 : floorlog2(x - 1) + 1;
}

class Simulation
{
public:
	using StateWrap = uint8_t;
	using States = std::vector<StateWrap>;
	using BitAddress = size_t;

	static constexpr size_t encodedCount = ceillog2(sizeof(StateWrap) * 8);
	static constexpr size_t encodedPattern  = (sizeof(StateWrap) * 8) - 1;
	
	States states;
	
	bool getState(BitAddress index)
	{  
		return states[index >> encodedCount] & (1 << (index & encodedPattern));
	}
	
	void setState(BitAddress index, bool state)
	{
		if(state)
		{
			states[index >> encodedCount] |= (1 << (index & encodedPattern));
		}
		else
		{
			states[index >> encodedCount] &= ~(1 << (index & encodedPattern));
		}
	}

	enum GateType {AND, OR, XOR, NOT};

	struct Gate
	{
		GateType type;
		BitAddress i1;
		BitAddress i2;
		BitAddress o1;
	};

	std::vector<Gate> gates;
	std::vector<size_t> gatesOrder;

	void generateOrder()
	{
		gatesOrder.clear();

		std::unordered_set<size_t> circuitOutputs;
		std::unordered_set<size_t> circuitInputs;

		std::unordered_set<size_t> allNodes;
		std::unordered_set<size_t> allInputs;
		std::unordered_set<size_t> allOutputs;

		for(const auto& gate : gates)
		{
			allNodes.insert(gate.i1);
			allNodes.insert(gate.i2);
			allNodes.insert(gate.o1);

			allInputs.insert(gate.i1);
			allInputs.insert(gate.i2);
			allOutputs.insert(gate.o1);
		}

		for(const auto input : allInputs)
		{
			if(!allOutputs.contains(input))
			{
				circuitInputs.insert(input);
			}
		}

		for(const auto output : allOutputs)
		{
			if(!allInputs.contains(output))
			{
				circuitOutputs.insert(output);
			}
		}

		std::cout << "Inputs: ";
		for(const auto input : circuitInputs)
		{
			std::cout << input <<  ", ";
		}
		std::cout << std::endl;

		std::cout << "Outputs: ";
		for(const auto output : circuitOutputs)
		{
			std::cout << output <<  ", ";
		}
		std::cout << std::endl;
	}

	void simulate()
	{
		generateOrder();

		for(const auto gateIndex : gatesOrder)
		{
			const auto& gate = gates[gateIndex];
			const bool state1 = getState(gate.i1); 
			const bool state2 = getState(gate.i2);
			bool output;

			if(gate.type == GateType::AND)
			{
				output = state1 && state2;
			}
			else if(gate.type == GateType::OR)
			{
				output = state1 || state2;
			}
			else if(gate.type == GateType::XOR)
			{
				output = state1 != state2;
			}
			else if(gate.type == GateType::NOT)
			{
				output = !state1;
			}

			setState(gate.o1, output);
		}
	}
};

Simulation sim;

//EM_EXPORT main
int main()
{
	sim.states.resize(64);
	sim.setState(0, 0);
	sim.setState(1, 1);
	sim.setState(2, 0);

	sim.gates.push_back({
		Simulation::GateType::XOR,
		0, 1, 
		2
	});

	sim.gates.push_back({
		Simulation::GateType::AND,
		2, 3, 
		4
	});
}

extern "C"
{
	//EM_EXPORT getState
	bool getState(Simulation::BitAddress addr)
	{
		return sim.getState(addr);
	}

	//EM_EXPORT setState
	void setState(Simulation::BitAddress addr, bool state)
	{
		sim.setState(addr, state);
	}

	//EM_EXPORT test
	size_t test(size_t i)
	{
		return sim.states[i];
	}

	//EM_EXPORT simulate
	void simulate()
	{
		sim.simulate();
	}
}