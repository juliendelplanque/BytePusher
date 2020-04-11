Class {
	#name : #BPAssemblerTest,
	#superclass : #TestCase,
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Assembler-Tests-Assembler'
}

{ #category : #helpers }
BPAssemblerTest >> generateFibonacciCodeIn: assembly withSubroutineInput: x [
	assembly
		pushOnDataStack: x; "fibo(x)="
		call: #fibo;
		popFromDataStack: #A;
		jump: #end;

		"fib subroutine, pop the fibonnaci number to compute and push the value of this number."
		label: #fibo;
		popFromDataStack: #A; "The fibonnaci number to compute"
		cmp: #A with: 0;
		jumpIfEqual: #fib_zero;
		cmp: #A with: 1;
		jumpIfEqual: #fib_one;
		"General case, do recursion."
		"fib(n-1)"
		decrement: #A;
		pushOnDataStack: #A; "Backup actual A register value."
		pushOnDataStack: #A; "Pass actual A register value as argument to fibo subroutine."
		call: #fibo;
		popFromDataStack: #B; "B register holds fib(n-1) result."
		"fib(n-2)"
		popFromDataStack: #A; "Retrieve A register value that we saved."
		pushOnDataStack: #B; "Backup fib(n-1) value."
		decrement: #A;
		pushOnDataStack: #A; "Pass actual A register value as argument to fibo subroutine."
		call: #fibo;
		popFromDataStack: #A; "A register holds fib(n-2) result."
		popFromDataStack: #B; "B register holds fib(n-1) result."
		"A := fib(n-1)+fib(n-2)"
		simpleAdd: #A to: #B;
		pushOnDataStack: #A;
		return;
		"fib(0)=0"
		label: #fib_zero;
			pushOnDataStack: 0;
			return;
		"fib(1)=1"
		label: #fib_one;
			pushOnDataStack: 1;
			return;
		
		label: #end;
			nop.
]

{ #category : #test }
BPAssemblerTest >> test2AddCompare [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		move: 1 to: #A; "1 instruction"
		add: #A to: 1; "9 instructions"
		add: #A to: 1; "9 instructions"
		cmp: #A with: 5. "3 instructions"
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	22 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 3.
	self assert: ((assembly registerNamed: #ZERO) address access: memory) equals: FALSE_VALUE.
]

{ #category : #test }
BPAssemblerTest >> testAddTo [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		move: 5 to: #A; "1 instruction"
		move: 6 to: #B; "1 instruction"
		add: #A to: #B. "9 instructions"
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	11 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 11.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 6.
]

{ #category : #test }
BPAssemblerTest >> testAddTo2 [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		move: 5 to: #A; "1 instruction"
		add: #A to: 6. "9 instructions"
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	10 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 11.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 0.
]

{ #category : #test }
BPAssemblerTest >> testAddToThenMoveTo [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		move: 5 to: #A;
		move: 6 to: #B;
		add: #A to: #B;
		move: #A to: #B.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	12 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 11.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 11.
]

{ #category : #test }
BPAssemblerTest >> testCall [
	| assembly vm memory expectedAddressPushed |
	assembly := BPAssembler new.
	
	assembly
		call: #subroutine; "16 instructions"
		move: 43 to: #A; "1 instruction"
		
		label: #subroutine;
		move: 42 to: #A. "1 instruction"
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	16 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #RETURN_SP) address access: memory) equals: 3.
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 42.
	expectedAddressPushed := assembly memoryLayout firstGenerationAddress + (13*INSTRUCTION_SIZE).
	self
		assert: ((assembly reservedMemoryZoneNamed: #RETURN_STACK) address access: memory)
		equals: expectedAddressPushed higherByte.
	self
		assert: ((assembly reservedMemoryZoneNamed: #RETURN_STACK) address + 1 access: memory)
		equals: expectedAddressPushed middleByte.
	self
		assert: ((assembly reservedMemoryZoneNamed: #RETURN_STACK) address + 2 access: memory)
		equals: expectedAddressPushed lowerByte.
]

{ #category : #test }
BPAssemblerTest >> testCmpWith [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		move: 5 to: #A;
		move: 6 to: #B;
		cmp: #A with: #B.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	7 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #ZERO) address access: memory) equals: FALSE_VALUE.
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 5.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 6.
]

{ #category : #test }
BPAssemblerTest >> testCmpWith2 [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		move: 6 to: #A;
		move: 6 to: #B;
		cmp: #A with: #B.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	7 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #ZERO) address access: memory) equals: TRUE_VALUE.
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 6.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 6.
]

{ #category : #test }
BPAssemblerTest >> testCmpWith3 [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		move: 6 to: #A;
		cmp: #A with: 5.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	4 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #ZERO) address access: memory) equals: FALSE_VALUE.
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 6.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 0.
]

{ #category : #test }
BPAssemblerTest >> testCmpWith4 [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		move: 6 to: #A;
		cmp: #A with: 6.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	4 timesRepeat: [ vm executeInnerLoop ].
	self assert: ((assembly registerNamed: #ZERO) address access: memory) equals: TRUE_VALUE.
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 6.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 0.
]

{ #category : #test }
BPAssemblerTest >> testCounter [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		move: 1 to: #A;
		label: #count;
			add: #A to: 1;
			cmp: #A with: 5;
			jumpIfNotEqual: #count.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	100 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 5
]

{ #category : #test }
BPAssemblerTest >> testCounterWithIncrement [
	| assembler vm memory |
	assembler := BPAssembler new.
	
	assembler
		move: 1 to: #A;
		label: #count;
			increment: #A;
			cmp: #A with: 5;
			jumpIfNotEqual: #count.
	
	memory := assembler assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	100 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembler registerNamed: #A) address access: memory) equals: 5
]

{ #category : #test }
BPAssemblerTest >> testDataStack [
| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		move: 42 to: #A; "1 instruction"
		pushOnDataStack: #A; "4 instructions"
		simpleAdd: #A to: 2; "3 instructions"
		popFromDataStack: #B. "4 instructions"
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	12 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #SP) address access: memory) equals: 0.
	self assert: ((assembly reservedMemoryZoneNamed: #DATA_STACK) address access: memory) equals: 42.
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 44.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 42
]

{ #category : #test }
BPAssemblerTest >> testDataStack2 [
| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		move: 42 to: #A; "1 instruction"
		pushOnDataStack: #A; "4 instructions"
		simpleAdd: #A to: 2; "3 instructions"
		pushOnDataStack: #A. "4 instructions"
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	12 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #SP) address access: memory) equals: 2.
	self assert: ((assembly reservedMemoryZoneNamed: #DATA_STACK) address access: memory) equals: 42.
	self assert: ((assembly reservedMemoryZoneNamed: #DATA_STACK) address + 1 access: memory) equals: 44.
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 44
]

{ #category : #test }
BPAssemblerTest >> testDecrement [
	| assembler vm memory |
	assembler := BPAssembler new.
	
	assembler
		move: 5 to: #A; "1 instruction"
		decrement: #A. "2 instructions"
	
	memory := assembler assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	3 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembler registerNamed: #A) address access: memory) equals: 4.
]

{ #category : #test }
BPAssemblerTest >> testDecrement2 [
	| assembler vm memory |
	assembler := BPAssembler new.
	
	assembler
		move: 5 to: #A; "1 instruction"
		move: 1 to: #B; "1 instruction"
		decrement: #A; "2 instructions"
		decrement: #B. "2 instructions"
	
	memory := assembler assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	6 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembler registerNamed: #A) address access: memory) equals: 4.
	self assert: ((assembler registerNamed: #B) address access: memory) equals: 0.
]

{ #category : #test }
BPAssemblerTest >> testDecrement3 [
	| assembler vm memory |
	assembler := BPAssembler new.
	
	assembler
		move: 0 to: #A; "1 instruction"
		decrement: #A. "2 instructions"
	
	memory := assembler assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	3 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembler registerNamed: #A) address access: memory) equals: 255.
]

{ #category : #test }
BPAssemblerTest >> testDecrementAddress [
	| assembler vm memory |
	assembler := BPAssembler new.
	
	assembler
		move: 0 to: #A;
		move: 0 to: #B;
		move: 0 to: #C;
		decrementAddress.
	
	memory := assembler assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	vm executeOuterLoop.
	
	self assert: ((assembler registerNamed: #A) valueIn: memory) equals: 255.
	self assert: ((assembler registerNamed: #B) valueIn: memory) equals: 255.
	self assert: ((assembler registerNamed: #C) valueIn: memory) equals: 255.
]

{ #category : #test }
BPAssemblerTest >> testDecrementAddress2 [
	| assembler vm memory |
	assembler := BPAssembler new.
	
	assembler
		move: 0 to: #A;
		move: 0 to: #B;
		move: 255 to: #C;
		decrementAddress.
	
	memory := assembler assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	vm executeOuterLoop.
	
	self assert: ((assembler registerNamed: #A) valueIn: memory) equals: 255.
	self assert: ((assembler registerNamed: #B) valueIn: memory) equals: 255.
	self assert: ((assembler registerNamed: #C) valueIn: memory) equals: 254.
]

{ #category : #test }
BPAssemblerTest >> testDecrementAddressAtDataStackTop [
	| assembler vm memory stack |
	assembler := BPAssembler new.
	
	assembler
		move: 42 to: #A;
		move: 43 to: #B;
		move: 44 to: #C;
		pushOnDataStack: 1;
		pushOnDataStack: 0;
		pushOnDataStack: 0;
		decrementAddressAtDataStackTop.
	
	memory := assembler assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	vm executeOuterLoop.
	
	self assert: ((assembler registerNamed: #A) valueIn: memory) equals: 42.
	self assert: ((assembler registerNamed: #B) valueIn: memory) equals: 43.
	self assert: ((assembler registerNamed: #C) valueIn: memory) equals: 44.
	stack := assembler memoryLayout extractDataStack: memory.
	self assert: stack size equals: 3.
	self assert: stack pop equals: 0.
	self assert: stack pop equals: 0.
	self assert: stack pop equals: 0.
	self assert: stack isEmpty
]

{ #category : #test }
BPAssemblerTest >> testFetchDataAtAddressAtDataStackTopInto [
	| assembler vm memory stack |
	assembler := BPAssembler new.
	assembler
		jump: #data_end;
		label: #my_6_bytes;
		nop;nop; "Allocate  6 bytes"
		label: #data_end;
		move: 42 to: #A;
		move: 43 to: #B;
		move: 44 to: #C;
		move: 45 to: #D;
		pushAddressOfLabelOnDataStack: #my_6_bytes;
		fetchDataAtAddressAtDataStackTopInto: #A.

	memory := assembler assemble serialize.
	vm := BPVirtualMachine new
			memory: memory;
			loadProgramCounter;
			yourself.
			
	vm executeOuterLoop.
	
	self assert: ((assembler memoryLayout registerNamed: #A) valueIn: memory) equals: 0.
	self assert: ((assembler memoryLayout registerNamed: #B) valueIn: memory) equals: 43.
	self assert: ((assembler memoryLayout registerNamed: #C) valueIn: memory) equals: 44.
	self assert: ((assembler memoryLayout registerNamed: #D) valueIn: memory) equals: 45.
	
	"Address should still be on stack."
	stack := assembler memoryLayout extractDataStack: memory.
	self assert: stack size equals: 3.
]

{ #category : #test }
BPAssemblerTest >> testFetchDataAtAddressInto [
	| assembler vm memory |
	assembler := BPAssembler new.
	assembler
		jump: #data_end;
		label: #my_6_bytes;
		nop;nop; "Allocate  6 bytes"
		label: #data_end;
		pushAddressOfLabelOnDataStack: #my_6_bytes;
		popFromDataStack: #C;
		popFromDataStack: #B;
		popFromDataStack: #A;
		fetchDataAtAddressInto: #A.

	memory := assembler assemble serialize.
	vm := BPVirtualMachine new
			memory: memory;
			loadProgramCounter;
			yourself.
			
	vm executeOuterLoop.
	
	self assert: ((assembler memoryLayout registerNamed: #A) valueIn: memory) equals: 0
]

{ #category : #test }
BPAssemblerTest >> testFibonacci [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		move: 1 to: #A;
		move: 1 to: #B;
		move: 1 to: #C;
		label: #fibo;
			move: #A to: #D;
			add: #A to: #B;
			move: #D to: #B;
			add: #C to: 1;
			cmp: #C with: 5;
			jumpIfNotEqual: #fibo.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	200 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 8.
	self assert: ((assembly registerNamed: #C) address access: memory) equals: 5
]

{ #category : #test }
BPAssemblerTest >> testIncrement [
	| assembler vm memory |
	assembler := BPAssembler new.
	
	assembler
		move: 5 to: #A; "1 instruction"
		increment: #A. "2 instructions"
	
	memory := assembler assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	3 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembler registerNamed: #A) address access: memory) equals: 6.
]

{ #category : #test }
BPAssemblerTest >> testIncrement2 [
	| assembler vm memory |
	assembler := BPAssembler new.
	
	assembler
		move: 5 to: #A; "1 instruction"
		move: 1 to: #B; "1 instruction"
		increment: #A; "2 instructions"
		increment: #B. "2 instructions"
	
	memory := assembler assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	6 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembler registerNamed: #A) address access: memory) equals: 6.
	self assert: ((assembler registerNamed: #B) address access: memory) equals: 2.
]

{ #category : #test }
BPAssemblerTest >> testIncrement3 [
	| assembler vm memory |
	assembler := BPAssembler new.
	
	assembler
		move: 255 to: #A; "1 instruction"
		increment: #A. "2 instructions"
	
	memory := assembler assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	3 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembler registerNamed: #A) address access: memory) equals: 0.
]

{ #category : #test }
BPAssemblerTest >> testIncrementAddress [
	| assembler vm memory |
	assembler := BPAssembler new.
	
	assembler
		move: 0 to: #A;
		move: 0 to: #B;
		move: 0 to: #C;
		incrementAddress.
	
	memory := assembler assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	vm executeOuterLoop.
	
	self assert: ((assembler registerNamed: #A) valueIn: memory) equals: 0.
	self assert: ((assembler registerNamed: #B) valueIn: memory) equals: 0.
	self assert: ((assembler registerNamed: #C) valueIn: memory) equals: 1.
]

{ #category : #test }
BPAssemblerTest >> testIncrementAddress2 [
	| assembler vm memory |
	assembler := BPAssembler new.
	
	assembler
		move: 0 to: #A;
		move: 0 to: #B;
		move: 255 to: #C;
		incrementAddress.
	
	memory := assembler assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	vm executeOuterLoop.
	
	self assert: ((assembler registerNamed: #A) valueIn: memory) equals: 0.
	self assert: ((assembler registerNamed: #B) valueIn: memory) equals: 1.
	self assert: ((assembler registerNamed: #C) valueIn: memory) equals: 0.
]

{ #category : #test }
BPAssemblerTest >> testIncrementAddress3 [
	| assembler vm memory |
	assembler := BPAssembler new.
	
	assembler
		move: 0 to: #A;
		move: 255 to: #B;
		move: 255 to: #C;
		incrementAddress.
	
	memory := assembler assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	vm executeOuterLoop.
	
	self assert: ((assembler registerNamed: #A) valueIn: memory) equals: 1.
	self assert: ((assembler registerNamed: #B) valueIn: memory) equals: 0.
	self assert: ((assembler registerNamed: #C) valueIn: memory) equals: 0.
]

{ #category : #test }
BPAssemblerTest >> testIncrementAddress4 [
	| assembler vm memory |
	assembler := BPAssembler new.
	
	assembler
		move: 255 to: #A;
		move: 255 to: #B;
		move: 255 to: #C;
		incrementAddress.
	
	memory := assembler assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	vm executeOuterLoop.
	
	self assert: ((assembler registerNamed: #A) valueIn: memory) equals: 0.
	self assert: ((assembler registerNamed: #B) valueIn: memory) equals: 0.
	self assert: ((assembler registerNamed: #C) valueIn: memory) equals: 0
]

{ #category : #test }
BPAssemblerTest >> testIncrementAddressAtDataStackTop [
	| assembler vm memory stack |
	assembler := BPAssembler new.
	
	assembler
		move: 42 to: #A;
		move: 43 to: #B;
		move: 44 to: #C;
		pushOnDataStack: 0;
		pushOnDataStack: 0;
		pushOnDataStack: 0;
		incrementAddressAtDataStackTop.
	
	memory := assembler assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	vm executeOuterLoop.
	
	self assert: ((assembler registerNamed: #A) valueIn: memory) equals: 42.
	self assert: ((assembler registerNamed: #B) valueIn: memory) equals: 43.
	self assert: ((assembler registerNamed: #C) valueIn: memory) equals: 44.
	stack := assembler memoryLayout extractDataStack: memory.
	self assert: stack size equals: 3.
	self assert: stack pop equals: 1.
	self assert: stack pop equals: 0.
	self assert: stack pop equals: 0.
	self assert: stack isEmpty
]

{ #category : #test }
BPAssemblerTest >> testInitialize [
	| assembly |
	assembly := BPAssembler new.
	
	self assert: assembly instructions isEmpty.
]

{ #category : #test }
BPAssemblerTest >> testJump [
	| assembly vm memoryBeforeStep memory |
	assembly := BPAssembler new.
	assembly jump: (BPAddress memoryAddress: 16rE0000).
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	memoryBeforeStep := memory copy.
	
	vm executeInnerLoop.
	
	self assert: vm programCounter equals: 16rE0000.
	self assert: vm memory equals: memoryBeforeStep
]

{ #category : #test }
BPAssemblerTest >> testJump2 [
	| assembly vm memoryBeforeStep memory |
	assembly := BPAssembler new.
	assembly jump: 16rE0000 asBPAddress.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	memoryBeforeStep := memory copy.
	
	vm executeInnerLoop.
	
	self assert: vm programCounter equals: 16rE0000.
	self assert: vm memory equals: memoryBeforeStep
]

{ #category : #test }
BPAssemblerTest >> testJumpIfEqual [
	| assembly vm memory assembled |
	assembly := BPAssembler new.
	
	assembly
		move: 6 to: #A;"1 instructions"
		move: 6 to: #B;"1 instructions"
		label: #firstMove;
		cmp: #A with: #B; "3 instructions"
		jumpIfEqual: #firstMove. "8 instructions"
	
	assembled := assembly assemble.
	memory := assembled serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	13 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #ZERO) address access: memory) equals: TRUE_VALUE.
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 6.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 6.
	self assert: vm programCounter equals: (assembled labelNamed: #firstMove) address memoryAddress
]

{ #category : #test }
BPAssemblerTest >> testJumpIfEqual2 [
	| assembly vm memory |
	assembly := BPAssembler new.

	assembly
		move: 4 to: #A; "1 instructions"
		move: 5 to: #B; "1 instructions"
		label: #firstMove;
		add: #A to: 1; "9 instructions"
		cmp: #A with: #B; "3 instructions"
		jumpIfNotEqual: #firstMove; "8 instructions"
		move: 3 to: #C. "1 instructions"
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	45 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 5.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 5.
	self assert: ((assembly registerNamed: #C) address access: memory) equals: 3.
]

{ #category : #test }
BPAssemblerTest >> testJumpIfEqual3 [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		move: 5 to: #A;
		move: 6 to: #B;
		label: #firstMove;
		add: #A to: 1;
		cmp: #A with: #B; "3 instructions"
		jumpIfEqual: #firstMove; "2 instructions"
		move: #B to: #C. 
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	100 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 7.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 6.
	self assert: ((assembly registerNamed: #C) address access: memory) equals: 6
]

{ #category : #test }
BPAssemblerTest >> testJumpIfEqual4 [
	| assembly vm memory |
	assembly := BPAssembler new.
	assembly
		move: 5 to: #A;
		move: 6 to: #B;
		label: #firstMove;
			add: #A to: 1;
			cmp: #A with: #B;
			jumpIfEqual: #firstMove;
		add: #B to: 1. 
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	100 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 7.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 7
]

{ #category : #test }
BPAssemblerTest >> testJumpIfNotEqual [
	| assembly vm memory assembled |
	assembly := BPAssembler new.
	
	assembly
		move: 5 to: #A;"1 instructions"
		move: 6 to: #B;"1 instructions"
		label: #firstMove;
		cmp: #A with: #B; "3 instructions"
		jumpIfNotEqual: #firstMove. "8 instructions"
	
	assembled := assembly assemble.
	memory := assembled serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	13 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #ZERO) address access: memory) equals: FALSE_VALUE.
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 5.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 6.
	self assert: vm programCounter equals: (assembled labelNamed: #firstMove) address memoryAddress
]

{ #category : #test }
BPAssemblerTest >> testJumpIfNotEqual2 [
	| assembly vm memory |
	assembly := BPAssembler new.

	assembly
		move: 4 to: #A; "1 instructions"
		move: 6 to: #B; "1 instructions"
		label: #firstMove;
		add: #A to: 1; "9 instructions"
		cmp: #A with: #B; "3 instructions"
		jumpIfNotEqual: #firstMove; "8 instructions"
		move: 3 to: #C. "1 instructions"
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	45 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 6.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 6.
	self assert: ((assembly registerNamed: #C) address access: memory) equals: 3.
]

{ #category : #test }
BPAssemblerTest >> testJumpIfNotEqual3 [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		move: 4 to: #A;
		move: 6 to: #B;
		label: #firstMove;
		add: #A to: 1;
		cmp: #A with: #B; "3 instructions"
		jumpIfNotEqual: #firstMove; "2 instructions"
		move: #B to: #C. 
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	100 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 6.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 6.
	self assert: ((assembly registerNamed: #C) address access: memory) equals: 6
]

{ #category : #test }
BPAssemblerTest >> testJumpIfNotEqual4 [
	| assembly vm memory |
	assembly := BPAssembler new.
	assembly
		move: 4 to: #A;
		move: 6 to: #B;
		label: #firstMove;
			add: #A to: 1;
			cmp: #A with: #B;
			jumpIfNotEqual: #firstMove;
		add: #B to: 1. 
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	100 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 6.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 7
]

{ #category : #test }
BPAssemblerTest >> testJumpIfNotEqual5 [
	| assembly vm memory |
	assembly := BPAssembler new.
	assembly
		move: 16r00 to: #A;
		move: 16r00 to: #B;
		label: #start;
			add: #B to: 1;
			cmp: #B with: 254;
			jumpIfNotEqual: #start;
		add: #A to: 1;
		move: 16r00 to: #B.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	vm executeOuterLoop.
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 1.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 0
]

{ #category : #test }
BPAssemblerTest >> testJumpIfNotEqual6 [
	| assembly vm memory |
	assembly := BPAssembler new.
	assembly
		move: 0 to: #B;
		label: #first;
			move: 0 to: #A;
			label: #second;
				add: #A to: 1;
				cmp: #A with: 10;
				jumpIfNotEqual: #second;
			add: #B to: 1;
			cmp: #B with: 10;
			jumpIfNotEqual: #first.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	vm executeOuterLoop.
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 10.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 10
]

{ #category : #test }
BPAssemblerTest >> testMoveTo [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		move: 5 to: #A;
		move: 6 to: #B.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	2 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 5.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 6.
]

{ #category : #test }
BPAssemblerTest >> testMoveTo3 [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly move: 5 to: #A.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	vm executeInnerLoop.
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 5.
]

{ #category : #test }
BPAssemblerTest >> testMoveTo4 [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		move: 5 to: #A;
		move: 6 to: #B;
		move: #B to: #A.
		
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	3 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 6.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 6.
]

{ #category : #test }
BPAssemblerTest >> testMoveTo5 [
	| assembly vm memory |
	assembly := BPAssembler new.

	assembly
		move: 5 to: #A;
		move: 6 to: #B;
		move: 7 to: #C;
		move: #B to: #A;
		move: #C to: #B.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	5 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 6.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 7.
	self assert: ((assembly registerNamed: #C) address access: memory) equals: 7.
]

{ #category : #test }
BPAssemblerTest >> testPopFromDataStack [
| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		pushOnDataStack: 42; "4 instructions"
		popFromDataStack: #A. "4 instructions"
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	8 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #SP) address access: memory) equals: 0.
	self assert: ((assembly reservedMemoryZoneNamed: #DATA_STACK) address access: memory) equals: 42.
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 42
]

{ #category : #test }
BPAssemblerTest >> testPushAddressOfPCOnDataStack [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		pushAddressOfPCOnDataStack. "16 instructions"
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	16 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #RETURN_SP) address access: memory) equals: 3.
	self assert: ((assembly reservedMemoryZoneNamed: #RETURN_STACK) address access: memory) equals: (assembly memoryLayout firstGenerationAddress higherByte).
	self assert: ((assembly reservedMemoryZoneNamed: #RETURN_STACK) address + 1 access: memory) equals: (assembly memoryLayout firstGenerationAddress middleByte).
	self assert: ((assembly reservedMemoryZoneNamed: #RETURN_STACK) address + 2 access: memory) equals: (assembly memoryLayout firstGenerationAddress lowerByte).
]

{ #category : #test }
BPAssemblerTest >> testPushAddressOfPCOnDataStack2 [
	| assembly vm memory expectedSecondAddressPushed |
	assembly := BPAssembler new.
	
	assembly
		pushAddressOfPCOnDataStack; "16 instructions"
		move: 3 to: #A; "1 instruction"
		move: 4 to: #A; "1 instruction"
		pushAddressOfPCOnDataStack. "16 instructions"
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	34 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #RETURN_SP) address access: memory) equals: 6.
	self assert: ((assembly reservedMemoryZoneNamed: #RETURN_STACK) address access: memory) equals: (assembly memoryLayout firstGenerationAddress higherByte).
	self assert: ((assembly reservedMemoryZoneNamed: #RETURN_STACK) address + 1 access: memory) equals: (assembly memoryLayout firstGenerationAddress middleByte).
	self assert: ((assembly reservedMemoryZoneNamed: #RETURN_STACK) address + 2 access: memory) equals: (assembly memoryLayout firstGenerationAddress lowerByte).
	expectedSecondAddressPushed := assembly memoryLayout firstGenerationAddress + (14*INSTRUCTION_SIZE).
	self
		assert: ((assembly reservedMemoryZoneNamed: #RETURN_STACK) address + 3 access: memory)
		equals: expectedSecondAddressPushed higherByte.
	self
		assert: ((assembly reservedMemoryZoneNamed: #RETURN_STACK) address + 4 access: memory)
		equals: expectedSecondAddressPushed middleByte.
	self
		assert: ((assembly reservedMemoryZoneNamed: #RETURN_STACK) address + 5 access: memory)
		equals: expectedSecondAddressPushed lowerByte.
]

{ #category : #test }
BPAssemblerTest >> testPushOnDataStack [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		pushOnDataStack: 42. "4 instructions"
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	4 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #SP) address access: memory) equals: 1.
	self assert: ((assembly reservedMemoryZoneNamed: #DATA_STACK) address access: memory) equals: 42.
]

{ #category : #test }
BPAssemblerTest >> testReadPixel [
	| assembly vm assembled memory |
	assembly := BPAssembler new.
	
	assembly
		move: 16r05 to: #A;
		move: 16r00 to: #B;
		writePixel: 42;
		move: 16r05 to: #A;
		move: 16r00 to: #B;
		readPixel.
	
	assembled := assembly assemble.
	memory := assembled serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
				
	vm executeOuterLoop.
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 42.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 16r00.
	self assert: ((assembly reservedMemoryZoneNamed: #DISPLAY_FRAME) address + 16r0500 access: memory) equals: 42
]

{ #category : #test }
BPAssemblerTest >> testRecursiveFibonacci0 [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	self generateFibonacciCodeIn: assembly withSubroutineInput: 0.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	vm executeOuterLoop.
	
	self assert: ((assembly registerNamed: #A) valueIn: memory) equals: 0.
	self assert: (assembly memoryLayout extractDataStack: memory) isEmpty.
	self assert: (assembly memoryLayout extractReturnStack: memory) isEmpty.
]

{ #category : #test }
BPAssemblerTest >> testRecursiveFibonacci1 [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	self generateFibonacciCodeIn: assembly withSubroutineInput: 1.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	vm executeOuterLoop.
	
	self assert: ((assembly registerNamed: #A) valueIn: memory) equals: 1.
	self assert: (assembly memoryLayout extractDataStack: memory) isEmpty.
	self assert: (assembly memoryLayout extractReturnStack: memory) isEmpty.
]

{ #category : #test }
BPAssemblerTest >> testRecursiveFibonacci2 [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	self generateFibonacciCodeIn: assembly withSubroutineInput: 2.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	vm executeOuterLoop.
	
	self assert: ((assembly registerNamed: #A) valueIn: memory) equals: 1.
	self assert: (assembly memoryLayout extractDataStack: memory) isEmpty.
	self assert: (assembly memoryLayout extractReturnStack: memory) isEmpty.
]

{ #category : #test }
BPAssemblerTest >> testRecursiveFibonacci3 [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	self generateFibonacciCodeIn: assembly withSubroutineInput: 3.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	vm executeOuterLoop.
	
	self assert: ((assembly registerNamed: #A) valueIn: memory) equals: 2.
	self assert: (assembly memoryLayout extractDataStack: memory) isEmpty.
	self assert: (assembly memoryLayout extractReturnStack: memory) isEmpty.
]

{ #category : #test }
BPAssemblerTest >> testRecursiveFibonacci4 [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	self generateFibonacciCodeIn: assembly withSubroutineInput: 4.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	vm executeOuterLoop.
	
	self assert: ((assembly registerNamed: #A) valueIn: memory) equals: 3.
	self assert: (assembly memoryLayout extractDataStack: memory) isEmpty.
	self assert: (assembly memoryLayout extractReturnStack: memory) isEmpty.
]

{ #category : #test }
BPAssemblerTest >> testRecursiveFibonacci5 [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	self generateFibonacciCodeIn: assembly withSubroutineInput: 5.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	vm executeOuterLoop.
	
	self assert: ((assembly registerNamed: #A) valueIn: memory) equals: 5.
	self assert: (assembly memoryLayout extractDataStack: memory) isEmpty.
	self assert: (assembly memoryLayout extractReturnStack: memory) isEmpty.
]

{ #category : #test }
BPAssemblerTest >> testRecursiveFibonacci6 [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	self generateFibonacciCodeIn: assembly withSubroutineInput: 6.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	vm executeOuterLoop.
	
	self assert: ((assembly registerNamed: #A) valueIn: memory) equals: 8.
	self assert: (assembly memoryLayout extractDataStack: memory) isEmpty.
	self assert: (assembly memoryLayout extractReturnStack: memory) isEmpty.
]

{ #category : #test }
BPAssemblerTest >> testRecursiveFibonacci7 [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	self generateFibonacciCodeIn: assembly withSubroutineInput: 7.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	vm executeOuterLoop.
	
	self assert: ((assembly registerNamed: #A) valueIn: memory) equals: 13.
	self assert: (assembly memoryLayout extractDataStack: memory) isEmpty.
	self assert: (assembly memoryLayout extractReturnStack: memory) isEmpty.
]

{ #category : #test }
BPAssemblerTest >> testReturn [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		call: #subroutine; "13 instructions"
		move: 43 to: #B; "1 instruction"
		
		label: #subroutine;
		move: 42 to: #A; "1 instruction"
		return. "13 instruction"
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	28 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #SP) address access: memory) equals: 0.
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 42.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 43.
]

{ #category : #test }
BPAssemblerTest >> testReturn2 [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		call: #subroutine; "13 instructions"
		move: 43 to: #B; "1 instruction"
		
		label: #subroutine;
		move: 42 to: #A; "1 instruction"
		pushOnDataStack: #A; "4 instructions"
		return. "13 instruction"
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	32 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #RETURN_SP) address access: memory) equals: 0.
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 42.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 43.
]

{ #category : #test }
BPAssemblerTest >> testSerializePC [
	| assembly vm memory assembled |
	assembly := BPAssembler new.
	
	assembly
		move: 5 to: #A;
		label: #foo;
		move: 6 to: #A;
		serializePC: #foo.
	
	assembled := assembly assemble.
	memory := assembled serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
				
	vm executeOuterLoop.
	
	self assert: vm loadProgramCounter programCounter asBPAddress equals: (assembled labelNamed:#foo) address.
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 6
]

{ #category : #test }
BPAssemblerTest >> testSerializePC2 [
	| assembly vm assembled memory |
	assembly := BPAssembler new.
	
	assembly
		move: 5 to: #A;
		label: #foo;
		serializePC: #foo;
		move: 6 to: #A.
	
	assembled := assembly assemble.
	memory := assembled serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
				
	vm executeOuterLoop.
	
	self assert: vm loadProgramCounter programCounter asBPAddress equals: (assembled labelNamed: #foo) address.
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 6
]

{ #category : #test }
BPAssemblerTest >> testSerializePC3 [
	| assembly vm assembled memory |
	assembly := BPAssembler new.
	
	assembly
		move: 16r00 to: #A;
		move: 16r00 to: #B;
		label: #start;
			add: #B to: 1;
			cmp: #B with: 100;
			jumpIfNotEqual: #start;
		add: #A to: 1;
		move: 16r00 to: #B;
	serializePC: #start.
	
	assembled := assembly assemble.
	memory := assembled serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
				
	vm executeOuterLoop.
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 1.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 0.
	self assert: vm loadProgramCounter programCounter asBPAddress equals: (assembled labelNamed: #start) address.
	
	vm executeOuterLoop.
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 2.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 0.
	self assert: vm loadProgramCounter programCounter asBPAddress equals: (assembled labelNamed: #start) address.
]

{ #category : #test }
BPAssemblerTest >> testSimpleAddTo [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		move: 5 to: #A; "1 instruction"
		move: 6 to: #B; "1 instruction"
		simpleAdd: #A to: #B. "3 instructions"
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	5 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 11.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 6.
]

{ #category : #test }
BPAssemblerTest >> testSimpleAddTo2 [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		move: 5 to: #A; "1 instruction"
		simpleAdd: #A to: 6. "3 instructions"
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	4 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 11.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 0.
]

{ #category : #test }
BPAssemblerTest >> testSimpleAddToThenMoveTo [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		move: 5 to: #A;
		move: 6 to: #B;
		simpleAdd: #A to: #B;
		move: #A to: #B.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	6 timesRepeat: [ vm executeInnerLoop ].
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 11.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 11.
]

{ #category : #test }
BPAssemblerTest >> testWritePixel [
	| assembly vm assembled memory |
	assembly := BPAssembler new.
	
	assembly
		move: 16r05 to: #A;
		move: 16r00 to: #B;
		writePixel: 42.
	
	assembled := assembly assemble.
	memory := assembled serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
				
	vm executeOuterLoop.
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 16r05.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 16r00.
	self assert: ((assembly reservedMemoryZoneNamed: #DISPLAY_FRAME) address + 16r0500 access: memory) equals: 42
]

{ #category : #test }
BPAssemblerTest >> testWritePixel2 [
	| assembly vm assembled memory |
	assembly := BPAssembler new.
	
	assembly
		move: 16r05 to: #A; "1 instruction"
		move: 16r00 to: #B; "1 instruction"
		writePixel: 42; "3 instruction"
		move: 16r00 to: #A;  "1 instruction"
		move: 16r05 to: #B;  "1 instruction"
		writePixel: 42.  "3 instruction"
	
	assembled := assembly assemble.
	memory := assembled serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.	
	vm executeOuterLoop.
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 16r00.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 16r05.
	self assert: ((assembly reservedMemoryZoneNamed: #DISPLAY_FRAME) address + 16r0005 access: memory) equals: 42.
	self assert: ((assembly reservedMemoryZoneNamed: #DISPLAY_FRAME) address + 16r0500 access: memory) equals: 42
]
