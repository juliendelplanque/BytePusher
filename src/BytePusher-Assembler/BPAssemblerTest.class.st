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
	| assembly vm |
	assembly := BPAssembler new.
	
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
BPAssemblerTest >> testAddTo [
	| assembly vm |
	assembly := BPAssembler new.
	
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
BPAssemblerTest >> testAddTo2 [
	| assembly vm |
	assembly := BPAssembler new.
	
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
BPAssemblerTest >> testAddToThenMoveTo [
	| assembly vm |
	assembly := BPAssembler new.
	
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
BPAssemblerTest >> testCmpWith [
	| assembly vm |
	assembly := BPAssembler new.
	
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
BPAssemblerTest >> testCmpWith2 [
	| assembly vm |
	assembly := BPAssembler new.
	
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
BPAssemblerTest >> testCmpWith3 [
	| assembly vm |
	assembly := BPAssembler new.
	
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
BPAssemblerTest >> testCmpWith4 [
	| assembly vm |
	assembly := BPAssembler new.
	
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
	| assembly vm memoryBeforeStep |
	assembly := BPAssembler new.
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
BPAssemblerTest >> testJump2 [
	| assembly vm memoryBeforeStep |
	assembly := BPAssembler new.
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
BPAssemblerTest >> testJumpIfNotEqual [
	| assembly vm |
	assembly := BPAssembler new.
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
BPAssemblerTest >> testMoveTo3 [
	| assembly vm |
	assembly := BPAssembler new.
	
	assembly move: 5 to: #A.
	
	vm := BPVirtualMachine new
				memory: assembly memory;
				loadProgramCounter;
				yourself.
	
	2 timesRepeat: [ vm innerStep ].
	
	self assert: (assembly memoryAt: (assembly registerNamed: #A) address memoryAddress) equals: 5.
]

{ #category : #test }
BPAssemblerTest >> testMoveTo4 [
	| assembly vm |
	assembly := BPAssembler new.
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
BPAssemblerTest >> testMoveTo5 [
	| assembly vm |
	assembly := BPAssembler new.
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
BPAssemblerTest >> testMoveTo6 [
	| assembly vm |
	assembly := BPAssembler new.
	
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
