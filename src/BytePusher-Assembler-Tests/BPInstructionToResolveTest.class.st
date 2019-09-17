"
A BPInstructionToResolveTest is a test class for testing the behavior of BPInstructionToResolve
"
Class {
	#name : #BPInstructionToResolveTest,
	#superclass : #TestCase,
	#category : #'BytePusher-Assembler-Tests-Model'
}

{ #category : #test }
BPInstructionToResolveTest >> testAsReference [

	self flag: #toImplement.
	self assert: false
]
