Class {
	#name : #BPAssemblerTest,
	#superclass : #TestCase,
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Assembler'
}

{ #category : #test }
BPAssemblerTest >> test2AddCompare [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		move: 1 to: #A;
		add: #A to: 1;
		add: #A to: 1;
		cmp: #A with: 5.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	100 timesRepeat: [ vm innerStep ].
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 3.
	self assert: ((assembly registerNamed: #ZERO) address access: memory) equals: 0.
]

{ #category : #test }
BPAssemblerTest >> testAddTo [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		move: 5 to: #A;
		move: 6 to: #B;
		add: #A to: #B.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	13 timesRepeat: [ vm innerStep ].
	
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 11.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 6.
]

{ #category : #test }
BPAssemblerTest >> testAddTo2 [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		move: 5 to: #A;
		add: #A to: 6.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	13 timesRepeat: [ vm innerStep ].
	
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
	
	6 timesRepeat: [ vm innerStep ].
	
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
	| assembly vm |
	assembly := BPAssembler new.
	
	assembly
		move: 1 to: #A;
		label: #count;
			add: #A to: 1;
			cmp: #A with: 5;
			jumpIfNotEqual: #count.
	
	vm := BPVirtualMachine new
				memory: assembly memory;
				loadProgramCounter;
				yourself.
	100 timesRepeat: [ vm innerStep ].
	
	self assert: (assembly memoryAt: (assembly registerNamed: #A) address memoryAddress) equals: 5
]

{ #category : #test }
BPAssemblerTest >> testFibonacci [
	| assembly vm |
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
	
	vm := BPVirtualMachine new
				memory: assembly memory;
				loadProgramCounter;
				yourself.
	100 timesRepeat: [ vm innerStep ].
	
	self assert: (assembly memoryAt: (assembly registerNamed: #C) address memoryAddress) equals: 5.
	self assert: (assembly memoryAt: (assembly registerNamed: #A) address memoryAddress) equals: 8
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
	assembly jump: (BPAddress memoryAddress: 16rE00000).
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	memoryBeforeStep := memory copy.
	
	vm innerStep.
	
	self assert: vm programCounter equals: 16rE00000.
	self assert: vm memory equals: memoryBeforeStep
]

{ #category : #test }
BPAssemblerTest >> testJump2 [
	| assembly vm memoryBeforeStep memory |
	assembly := BPAssembler new.
	assembly jump: 16rE00000 asBPAddress.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	memoryBeforeStep := memory copy.
	
	vm innerStep.
	
	self assert: vm programCounter equals: 16rE00000.
	self assert: vm memory equals: memoryBeforeStep
]

{ #category : #test }
BPAssemblerTest >> testJumpIfNotEqual [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		move: 5 to: #A;
		move: 6 to: #B;
		label: #firstMove;
		cmp: #A with: #B; "3 instructions"
		jumpIfNotEqual: #firstMove. "2 instructions"
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
				memory: memory;
				loadProgramCounter;
				yourself.
	
	5 timesRepeat: [ vm innerStep ].
	
	self assert: ((assembly registerNamed: #ZERO) address access: memory) equals: FALSE_VALUE.
	self assert: ((assembly registerNamed: #A) address access: memory) equals: 5.
	self assert: ((assembly registerNamed: #B) address access: memory) equals: 6.
	self assert: vm programCounter equals: (assembly labelNamed: #firstMove) address memoryAddress
]

{ #category : #test }
BPAssemblerTest >> testJumpIfNotEqual2 [
	| assembly vm |
	assembly := BPAssembler new.
	assembly memoryAt: (assembly registerNamed: #A) address memoryAddress put: 4.
	assembly memoryAt: (assembly registerNamed: #B) address memoryAddress put: 6.
	assembly
		label: #firstMove;
		add: #A to: 1;
		cmp: #A with: #B; "3 instructions"
		jumpIfNotEqual: #firstMove; "2 instructions"
		move: 3 to: #C. 
	
	vm := BPVirtualMachine new
				memory: assembly memory;
				loadProgramCounter;
				yourself.
	
	200 timesRepeat: [ vm innerStep ].
	
	self assert: (assembly memoryAt: (assembly registerNamed: #A) address memoryAddress) equals: 6.
	self assert: (assembly memoryAt: (assembly registerNamed: #B) address memoryAddress) equals: 6.
	self assert: (assembly memoryAt: (assembly registerNamed: #C) address memoryAddress) equals: 3.
]

{ #category : #test }
BPAssemblerTest >> testJumpIfNotEqual3 [
	| assembly vm |
	assembly := BPAssembler new.
	assembly memoryAt: (assembly registerNamed: #A) address memoryAddress put: 4.
	assembly memoryAt: (assembly registerNamed: #B) address memoryAddress put: 6.
	assembly
		label: #firstMove;
		add: #A to: 1;
		cmp: #A with: #B; "3 instructions"
		jumpIfNotEqual: #firstMove; "2 instructions"
		move: #B to: #C. 
	
	vm := BPVirtualMachine new
				memory: assembly memory;
				loadProgramCounter;
				yourself.
	
	100 timesRepeat: [ vm innerStep ].
	
	self assert: (assembly memoryAt: (assembly registerNamed: #A) address memoryAddress) equals: 6.
	self assert: (assembly memoryAt: (assembly registerNamed: #B) address memoryAddress) equals: 6.
	self assert: (assembly memoryAt: (assembly registerNamed: #C) address memoryAddress) equals: 6.
]

{ #category : #test }
BPAssemblerTest >> testJumpIfNotEqual4 [
	| assembly vm |
	assembly := BPAssembler new.
	assembly
		move: 4 to: #A;
		move: 6 to: #B;
		label: #firstMove;
			add: #A to: 1;
			cmp: #A with: #B;
			jumpIfNotEqual: #firstMove;
		add: #B to: 1. 
	
	vm := BPVirtualMachine new
				memory: assembly memory;
				loadProgramCounter;
				yourself.
	
	100 timesRepeat: [ vm innerStep ].
	
	self assert: (assembly memoryAt: (assembly registerNamed: #A) address memoryAddress) equals: 6.
	self assert: (assembly memoryAt: (assembly registerNamed: #B) address memoryAddress) equals: 7.
]

{ #category : #test }
BPAssemblerTest >> testJumpIfNotEqual5 [
	| assembly vm |
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
	
	vm := BPVirtualMachine new
				memory: assembly memory;
				yourself.
	
	vm step.
	
	self assert: (assembly memoryAt: (assembly registerNamed: #A) address memoryAddress) equals: 1.
	self assert: (assembly memoryAt: (assembly registerNamed: #B) address memoryAddress) equals: 0.
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
	| assembly vm |
	assembly := BPAssembler new.
	
	assembly
		move: 5 to: #A;
		label: #foo;
		move: 6 to: #A;
		serializePC: #foo.
	
	vm := BPVirtualMachine new
				memory: assembly memory;
				loadProgramCounter;
				yourself.
				
	vm step.
	
	self assert: vm loadProgramCounter programCounter asBPAddress equals: (assembly labelNamed:#foo) address.
	self assert: (assembly memoryAt: (assembly registerNamed: #A) address memoryAddress) equals: 6
]

{ #category : #test }
BPAssemblerTest >> testSerializePC2 [
	| assembly vm |
	assembly := BPAssembler new.
	
	assembly
		move: 5 to: #A;
		label: #foo;
		serializePC: #foo;
		move: 6 to: #A.
	
	vm := BPVirtualMachine new
				memory: assembly memory;
				loadProgramCounter;
				yourself.
				
	vm step.
	
	self assert: vm loadProgramCounter programCounter asBPAddress equals: (assembly labelNamed: #foo) address.
	self assert: (assembly memoryAt: (assembly registerNamed: #A) address memoryAddress) equals: 6
]

{ #category : #test }
BPAssemblerTest >> testSerializePC3 [
	| assembly vm |
	assembly := BPAssembler new.
	
	assembly
		move: 16r00 to: #A;
		move: 16r00 to: #B;
		label: #start;
			add: #B to: 1;
			cmp: #B with: 255;
			jumpIfNotEqual: #start;
		add: #A to: 1;
		move: 16r00 to: #B;
	serializePC: #start.
	
	vm := BPVirtualMachine new
				memory: assembly memory;
				yourself.
				
	vm step.
	self assert: (assembly memoryAt: (assembly registerNamed: #A) address memoryAddress) equals: 1.
	self assert: (assembly memoryAt: (assembly registerNamed: #B) address memoryAddress) equals: 0.
	self assert: vm loadProgramCounter programCounter asBPAddress equals: (assembly labelNamed: #start) address.
	
	vm step.
	self assert: (assembly memoryAt: (assembly registerNamed: #A) address memoryAddress) equals: 2.
	self assert: (assembly memoryAt: (assembly registerNamed: #B) address memoryAddress) equals: 0.
	self assert: vm loadProgramCounter programCounter asBPAddress equals: (assembly labelNamed: #start) address.
]
