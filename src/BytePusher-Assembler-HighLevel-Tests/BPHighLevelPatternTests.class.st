Class {
	#name : #BPHighLevelPatternTests,
	#superclass : #TestCase,
	#category : #'BytePusher-Assembler-HighLevel-Tests'
}

{ #category : #tests }
BPHighLevelPatternTests >> testIfEqualsThenElse [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		move: 43 to: #A;
	if: #A equals: 42 then: [ :a |
		a move: 1 to: #B ] else: [ :a | a move: 0 to: #B ];
	move: 1 to: #C.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
			memory: memory;
			loadProgramCounter;
			yourself.
			
	vm executeOuterLoop.
	
	self assert: ((assembly registerNamed: #A) valueIn: memory) equals: 43.
	self assert: ((assembly registerNamed: #B) valueIn: memory) equals: 0.
	self assert: ((assembly registerNamed: #C) valueIn: memory) equals: 1.
]

{ #category : #tests }
BPHighLevelPatternTests >> testIfEqualsThenElse2 [
	| assembly vm memory |
	assembly := BPAssembler new.
	
	assembly
		move: 42 to: #A;
	if: #A equals: 42 then: [ :a |
		a move: 1 to: #B ] else: [ :a | a move: 0 to: #B ];
	move: 1 to: #C.
	
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
			memory: memory;
			loadProgramCounter;
			yourself.
			
	vm executeOuterLoop.
	
	self assert: ((assembly registerNamed: #A) valueIn: memory) equals: 42.
	self assert: ((assembly registerNamed: #B) valueIn: memory) equals: 1.
	self assert: ((assembly registerNamed: #C) valueIn: memory) equals: 1.
]

{ #category : #tests }
BPHighLevelPatternTests >> testWhileIsNotEqualsDo [
	| assembly memory vm |
	assembly := BPAssembler new.
	assembly
		move: 42 to: #A;
		move: 0 to: #B;
		while: #A isNotEquals: #B do: [ :as | as increment: #B ];
		move: 1 to: #C.
	memory := assembly assemble serialize.
	vm := BPVirtualMachine new
		memory: memory;
		loadProgramCounter;
		yourself.
	vm executeOuterLoop.
	
	self assert: ((assembly registerNamed: #A) valueIn: memory) equals: 42.
	self assert: ((assembly registerNamed: #B) valueIn: memory) equals: 42.
	self assert: ((assembly registerNamed: #C) valueIn: memory) equals: 1.
]
