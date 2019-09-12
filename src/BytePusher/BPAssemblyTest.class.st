"
A BPAssemblyTest is a test class for testing the behavior of BPAssembly
"
Class {
	#name : #BPAssemblyTest,
	#superclass : #TestCase,
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Tests'
}

{ #category : #test }
BPAssemblyTest >> test2AddCompare [
	| assembly vm |
	assembly := BPAssembly new.
	
	assembly
		move: 1 to: #A;
		add: #A to: 1;
		add: #A to: 1;
		cmp: #A with: 5.
	
	vm := BPVirtualMachine new
				memory: assembly memory;
				loadProgramCounter;
				yourself.
	100 timesRepeat: [ vm innerStep ].
	
	self assert: (assembly memoryAt: (assembly registerNamed: #A) address memoryAddress) equals: 3.
	self assert: (assembly memoryAt: (assembly registerNamed: #ZERO) address memoryAddress) equals: 0
]

{ #category : #test }
BPAssemblyTest >> testAddTo [
	| assembly vm |
	assembly := BPAssembly new.
	
	(assembly registerNamed: #A) address store: 5 in: assembly memory.
	(assembly registerNamed: #B) address store: 6 in: assembly memory.
	
	assembly add: #A to: #B.
	
	vm := BPVirtualMachine new
				memory: assembly memory;
				loadProgramCounter;
				yourself.
	
	9 timesRepeat: [ vm innerStep ].
	
	self assert: ((assembly registerNamed: #A) address access: assembly memory) equals: 11.
	self assert: ((assembly registerNamed: #B) address access: assembly memory) equals: 6
]

{ #category : #test }
BPAssemblyTest >> testAddTo2 [
	| assembly vm |
	assembly := BPAssembly new.
	
	assembly memoryAt: (assembly registerNamed: #A) address memoryAddress put: 5.
	
	assembly add: #A to: 6.
	
	vm := BPVirtualMachine new
				memory: assembly memory;
				loadProgramCounter;
				yourself.
	
	10 timesRepeat: [ vm innerStep ].
	
	self assert: (assembly memoryAt: (assembly registerNamed: #A) address memoryAddress) equals: 11.
	self assert: (assembly memoryAt: (assembly registerNamed: #B) address memoryAddress) equals: 0
]

{ #category : #test }
BPAssemblyTest >> testAddToThenMoveTo [
	| assembly vm |
	assembly := BPAssembly new.
	
	assembly memoryAt: (assembly registerNamed: #A) address memoryAddress put: 5.
	assembly memoryAt: (assembly registerNamed: #B) address memoryAddress put: 6.
	
	assembly add: #A to: #B.
	assembly move: #A to: #B.
	
	vm := BPVirtualMachine new
				memory: assembly memory;
				loadProgramCounter;
				yourself.
	
	10 timesRepeat: [ vm innerStep ].
	
	self assert: (assembly memoryAt: (assembly registerNamed: #A) address memoryAddress) equals: 11.
	self assert: (assembly memoryAt: (assembly registerNamed: #B) address memoryAddress) equals: 11
]

{ #category : #test }
BPAssemblyTest >> testCmpWith [
	| assembly vm |
	assembly := BPAssembly new.
	
	assembly memoryAt: (assembly registerNamed: #A) address memoryAddress put: 5.
	assembly memoryAt: (assembly registerNamed: #B) address memoryAddress put: 6.
	
	assembly cmp: #A with: #B.
	
	vm := BPVirtualMachine new
				memory: assembly memory;
				loadProgramCounter;
				yourself.
	
	3 timesRepeat: [ vm innerStep ].
	
	self assert: (assembly memoryAt: (assembly registerNamed: #ZERO) address memoryAddress) equals: 0.
	self assert: (assembly memoryAt: (assembly registerNamed: #A) address memoryAddress) equals: 5.
	self assert: (assembly memoryAt: (assembly registerNamed: #B) address memoryAddress) equals: 6
]

{ #category : #test }
BPAssemblyTest >> testCmpWith2 [
	| assembly vm |
	assembly := BPAssembly new.
	
	assembly memoryAt: (assembly registerNamed: #A) address memoryAddress put: 6.
	assembly memoryAt: (assembly registerNamed: #B) address memoryAddress put: 6.
	
	assembly cmp: #A with: #B.
	
	vm := BPVirtualMachine new
				memory: assembly memory;
				loadProgramCounter;
				yourself.
	
	3 timesRepeat: [ vm innerStep ].
	
	self assert: (assembly memoryAt: (assembly registerNamed: #ZERO) address memoryAddress) equals: TRUE_VALUE.
	self assert: (assembly memoryAt: (assembly registerNamed: #A) address memoryAddress) equals: 6.
	self assert: (assembly memoryAt: (assembly registerNamed: #B) address memoryAddress) equals: 6
]

{ #category : #test }
BPAssemblyTest >> testCmpWith3 [
	| assembly vm |
	assembly := BPAssembly new.
	
	assembly memoryAt: (assembly registerNamed: #A) address memoryAddress put: 6.
	
	assembly cmp: #A with: 5.
	
	vm := BPVirtualMachine new
				memory: assembly memory;
				loadProgramCounter;
				yourself.
	
	4 timesRepeat: [ vm innerStep ].
	
	self assert: (assembly memoryAt: (assembly registerNamed: #ZERO) address memoryAddress) equals: 0.
	self assert: (assembly memoryAt: (assembly registerNamed: #A) address memoryAddress) equals: 6.
	self assert: (assembly memoryAt: (assembly registerNamed: #B) address memoryAddress) equals: 0
]

{ #category : #test }
BPAssemblyTest >> testCmpWith4 [
	| assembly vm |
	assembly := BPAssembly new.
	
	assembly memoryAt: (assembly registerNamed: #A) address memoryAddress put: 6.
	
	assembly cmp: #A with: 6.
	
	vm := BPVirtualMachine new
				memory: assembly memory;
				loadProgramCounter;
				yourself.
	
	4 timesRepeat: [ vm innerStep ].
	
	self assert: (assembly memoryAt: (assembly registerNamed: #ZERO) address memoryAddress) equals: TRUE_VALUE.
	self assert: (assembly memoryAt: (assembly registerNamed: #A) address memoryAddress) equals: 6.
	self assert: (assembly memoryAt: (assembly registerNamed: #B) address memoryAddress) equals: 0
]

{ #category : #test }
BPAssemblyTest >> testCounter [
	| assembly vm |
	assembly := BPAssembly new.
	
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
BPAssemblyTest >> testFibonacci [
	| assembly vm |
	assembly := BPAssembly new.
	
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
BPAssemblyTest >> testInitialize [
	| assembly |
	assembly := BPAssembly new.
	
	self assert: assembly registers size equals: 7.
	self assert: assembly addressOfNextInstructionToGenerate equals: 16r0020000 asBPAddress
]

{ #category : #test }
BPAssemblyTest >> testJump [
	| assembly vm memoryBeforeStep |
	assembly := BPAssembly new.
	assembly jump: (BPAddress memoryAddress: 16rE00000).
	
	vm := BPVirtualMachine new
				memory: assembly memory;
				loadProgramCounter;
				yourself.
	
	memoryBeforeStep := assembly memory copy.
	
	vm innerStep.
	
	self assert: vm programCounter equals: 16rE00000.
	self assert: assembly memory equals: memoryBeforeStep
]

{ #category : #test }
BPAssemblyTest >> testJump2 [
	| assembly vm memoryBeforeStep |
	assembly := BPAssembly new.
	assembly jump: 16rE00000 asBPAddress.
	
	vm := BPVirtualMachine new
				memory: assembly memory;
				loadProgramCounter;
				yourself.
	
	memoryBeforeStep := assembly memory copy.
	
	vm innerStep.
	
	self assert: vm programCounter equals: 16rE00000.
	self assert: assembly memory equals: memoryBeforeStep
]

{ #category : #test }
BPAssemblyTest >> testJumpIfNotEqual [
	| assembly vm |
	assembly := BPAssembly new.
	assembly memoryAt: (assembly registerNamed: #A) address memoryAddress put: 5.
	assembly memoryAt: (assembly registerNamed: #B) address memoryAddress put: 6.
	assembly
		label: #firstMove;
		cmp: #A with: #B; "3 instructions"
		jumpIfNotEqual: #firstMove. "2 instructions"
	
	vm := BPVirtualMachine new
				memory: assembly memory;
				loadProgramCounter;
				yourself.
	
	5 timesRepeat: [ vm innerStep ].
	
	self assert: (assembly memoryAt: (assembly registerNamed: #A) address memoryAddress) equals: 5.
	self assert: (assembly memoryAt: (assembly registerNamed: #B) address memoryAddress) equals: 6.
	self assert: (assembly memoryAt: (assembly registerNamed: #ZERO) address memoryAddress) equals: 0.
	self assert: vm programCounter equals: (assembly labelNamed: #firstMove) address memoryAddress
]

{ #category : #test }
BPAssemblyTest >> testJumpIfNotEqual2 [
	| assembly vm |
	assembly := BPAssembly new.
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
BPAssemblyTest >> testJumpIfNotEqual3 [
	| assembly vm |
	assembly := BPAssembly new.
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
BPAssemblyTest >> testJumpIfNotEqual4 [
	| assembly vm |
	assembly := BPAssembly new.
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
BPAssemblyTest >> testJumpIfNotEqual5 [
	| assembly vm |
	assembly := BPAssembly new.
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
BPAssemblyTest >> testMoveTo [
	| assembly lastInstructionMemoryAddress jumpMemoryAddress |
	assembly := BPAssembly new.
	
	assembly move: #A to: #B.
	
	lastInstructionMemoryAddress := assembly addressOfNextInstructionToGenerate memoryAddress - INSTRUCTION_SIZE.
	
	self assert: (assembly memoryAt: lastInstructionMemoryAddress) equals: 0.
	self assert: (assembly memoryAt: lastInstructionMemoryAddress + 1) equals:0.
	self assert: (assembly memoryAt: lastInstructionMemoryAddress + 2) equals: 16r08.
	
	self assert: (assembly memoryAt: lastInstructionMemoryAddress + 3) equals: 0.
	self assert: (assembly memoryAt: lastInstructionMemoryAddress + 4) equals: 0.
	self assert: (assembly memoryAt: lastInstructionMemoryAddress + 5) equals: 16r9.
	
	jumpMemoryAddress := lastInstructionMemoryAddress + INSTRUCTION_SIZE.
	
	self assert: (assembly memoryAt: lastInstructionMemoryAddress + 6) equals: (jumpMemoryAddress & 16rFF0000) >> 16.
	self assert: (assembly memoryAt: lastInstructionMemoryAddress + 7) equals: (jumpMemoryAddress & 16r00FF00) >> 8.
	self assert: (assembly memoryAt: lastInstructionMemoryAddress + 8) equals: (jumpMemoryAddress & 16r0000FF).
	
	
]

{ #category : #test }
BPAssemblyTest >> testMoveTo2 [
	| assembly lastInstructionMemoryAddress jumpMemoryAddress dataMemoryAddress |
	assembly := BPAssembly new.
	
	assembly move: 5 to: #B.
	
	lastInstructionMemoryAddress := assembly addressOfNextInstructionToGenerate memoryAddress - INSTRUCTION_SIZE.
	dataMemoryAddress := lastInstructionMemoryAddress - 1.
	
	self assert: (assembly memoryAt: dataMemoryAddress) equals: 5.
	
	self assert: (assembly memoryAt: lastInstructionMemoryAddress) equals: (dataMemoryAddress & 16rFF0000) >> 16.
	self assert: (assembly memoryAt: lastInstructionMemoryAddress + 1) equals: (dataMemoryAddress & 16r00FF00) >> 8.
	self assert: (assembly memoryAt: lastInstructionMemoryAddress + 2) equals: dataMemoryAddress & 16r0000FF.
	
	self assert: (assembly memoryAt: lastInstructionMemoryAddress + 3) equals: 0.
	self assert: (assembly memoryAt: lastInstructionMemoryAddress + 4) equals: 0.
	self assert: (assembly memoryAt: lastInstructionMemoryAddress + 5) equals: 16r9.
	
	jumpMemoryAddress := lastInstructionMemoryAddress + INSTRUCTION_SIZE.
	
	self assert: (assembly memoryAt: lastInstructionMemoryAddress + 6) equals: (jumpMemoryAddress & 16rFF0000) >> 16.
	self assert: (assembly memoryAt: lastInstructionMemoryAddress + 7) equals: (jumpMemoryAddress & 16r00FF00) >> 8.
	self assert: (assembly memoryAt: lastInstructionMemoryAddress + 8) equals: (jumpMemoryAddress & 16r0000FF).
	
	
]

{ #category : #test }
BPAssemblyTest >> testMoveTo3 [
	| assembly vm |
	assembly := BPAssembly new.
	
	assembly move: 5 to: #A.
	
	vm := BPVirtualMachine new
				memory: assembly memory;
				loadProgramCounter;
				yourself.
	
	2 timesRepeat: [ vm innerStep ].
	
	self assert: (assembly memoryAt: (assembly registerNamed: #A) address memoryAddress) equals: 5.
]

{ #category : #test }
BPAssemblyTest >> testMoveTo4 [
	| assembly vm |
	assembly := BPAssembly new.
	assembly memoryAt: (assembly registerNamed: #A) address memoryAddress put: 5.
	assembly memoryAt: (assembly registerNamed: #B) address memoryAddress put: 6.
	
	assembly move: #B to: #A.
	
	vm := BPVirtualMachine new
				memory: assembly memory;
				loadProgramCounter;
				yourself.
	
	1 timesRepeat: [ vm innerStep ].
	
	self assert: (assembly memoryAt: (assembly registerNamed: #A) address memoryAddress) equals: 6.
	self assert: (assembly memoryAt: (assembly registerNamed: #B) address memoryAddress) equals: 6.
]

{ #category : #test }
BPAssemblyTest >> testMoveTo5 [
	| assembly vm |
	assembly := BPAssembly new.
	assembly memoryAt: (assembly registerNamed: #A) address memoryAddress put: 5.
	assembly memoryAt: (assembly registerNamed: #B) address memoryAddress put: 6.
	assembly memoryAt: (assembly registerNamed: #C) address memoryAddress put: 7.
	
	assembly
		move: #B to: #A;
		move: #C to: #B.
	
	vm := BPVirtualMachine new
				memory: assembly memory;
				loadProgramCounter;
				yourself.
	
	2 timesRepeat: [ vm innerStep ].
	
	self assert: (assembly memoryAt: (assembly registerNamed: #A) address memoryAddress) equals: 6.
	self assert: (assembly memoryAt: (assembly registerNamed: #B) address memoryAddress) equals: 7.
	self assert: (assembly memoryAt: (assembly registerNamed: #C) address memoryAddress) equals: 7.
]

{ #category : #test }
BPAssemblyTest >> testMoveTo6 [
	| assembly vm |
	assembly := BPAssembly new.
	
	assembly
		move: 5 to: #A;
		move: 6 to: #B.
	
	vm := BPVirtualMachine new
				memory: assembly memory;
				loadProgramCounter;
				yourself.
	
	2 timesRepeat: [ vm innerStep ].
	
	self assert: (assembly memoryAt: (assembly registerNamed: #A) address memoryAddress) equals: 5.
	self assert: (assembly memoryAt: (assembly registerNamed: #B) address memoryAddress) equals: 6.
]

{ #category : #test }
BPAssemblyTest >> testSerializePC [
	| assembly vm |
	assembly := BPAssembly new.
	
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
BPAssemblyTest >> testSerializePC2 [
	| assembly vm |
	assembly := BPAssembly new.
	
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
BPAssemblyTest >> testSerializePC3 [
	| assembly vm |
	assembly := BPAssembly new.
	
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
