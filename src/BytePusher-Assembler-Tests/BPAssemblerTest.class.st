Class {
	#name : #BPAssemblerTest,
	#superclass : #TestCase,
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Assembler-Tests-Assembler'
}

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
	22 timesRepeat: [ vm innerStep ].
	
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
	
	11 timesRepeat: [ vm innerStep ].
	
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
	
	10 timesRepeat: [ vm innerStep ].
	
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
	
	12 timesRepeat: [ vm innerStep ].
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 11.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 11.
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
	
	7 timesRepeat: [ vm innerStep ].
	
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
	
	7 timesRepeat: [ vm innerStep ].
	
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
	
	4 timesRepeat: [ vm innerStep ].
	
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
	
	4 timesRepeat: [ vm innerStep ].
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
	100 timesRepeat: [ vm innerStep ].
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 5
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
	200 timesRepeat: [ vm innerStep ].
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 8.
	self assert: ((assembly registerNamed: #C) address access: memory) equals: 5
]

{ #category : #test }
BPAssemblerTest >> testIncrement [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		move: 5 to: #A; "1 instruction"
		increment: #A. "2 instructions"
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	3 timesRepeat: [ vm innerStep ].
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 6.
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
	
	vm innerStep.
	
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
	
	vm innerStep.
	
	self assert: vm programCounter equals: 16rE0000.
	self assert: vm memory equals: memoryBeforeStep
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
	
	13 timesRepeat: [ vm innerStep ].
	
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
	
	45 timesRepeat: [ vm innerStep ].
	
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
	
	100 timesRepeat: [ vm innerStep ].
	
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
	
	100 timesRepeat: [ vm innerStep ].
	
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
	
	vm step.
	
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
	
	vm step.
	
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
	
	2 timesRepeat: [ vm innerStep ].
	
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
	
	vm innerStep.
	
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
	
	3 timesRepeat: [ vm innerStep ].
	
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
	
	5 timesRepeat: [ vm innerStep ].
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 6.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 7.
	self assert: ((assembly registerNamed: #C) address access: memory) equals: 7.
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
				
	vm step.
	
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
				
	vm step.
	
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
				
	vm step.
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 1.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 0.
	self assert: vm loadProgramCounter programCounter asBPAddress equals: (assembled labelNamed: #start) address.
	
	vm step.
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
	
	5 timesRepeat: [ vm innerStep ].
	
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
	
	4 timesRepeat: [ vm innerStep ].
	
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
	
	6 timesRepeat: [ vm innerStep ].
	
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
				
	vm step.
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
	vm step.
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 16r00.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 16r05.
	self assert: ((assembly reservedMemoryZoneNamed: #DISPLAY_FRAME) address + 16r0005 access: memory) equals: 42.
	self assert: ((assembly reservedMemoryZoneNamed: #DISPLAY_FRAME) address + 16r0500 access: memory) equals: 42
]
