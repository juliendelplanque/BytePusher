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
BPAssemblyTest >> testInitialize [
	| assembly |
	assembly := BPAssembly new.
	
	self assert: assembly registers size equals: 5.
	self assert: assembly lastBPInstructionIndex equals: 13 asBPAddress
]

{ #category : #test }
BPAssemblyTest >> testMoveFromTo [
	| assembly lastInstructionMemoryAddress jumpMemoryAddress |
	assembly := BPAssembly new.
	
	assembly moveFrom: #A to: #B.
	
	lastInstructionMemoryAddress := assembly lastBPInstructionIndex memoryAddress.
	
	self assert: (assembly memoryAt: lastInstructionMemoryAddress) equals: 0.
	self assert: (assembly memoryAt: lastInstructionMemoryAddress + 1) equals:0.
	self assert: (assembly memoryAt: lastInstructionMemoryAddress + 2) equals: 16r09.
	
	self assert: (assembly memoryAt: lastInstructionMemoryAddress + 3) equals: 0.
	self assert: (assembly memoryAt: lastInstructionMemoryAddress + 4) equals: 0.
	self assert: (assembly memoryAt: lastInstructionMemoryAddress + 5) equals: 16rA.
	
	jumpMemoryAddress := lastInstructionMemoryAddress + INSTRUCTION_SIZE.
	
	self assert: (assembly memoryAt: lastInstructionMemoryAddress + 6) equals: (jumpMemoryAddress & 16rFF0000) >> 16.
	self assert: (assembly memoryAt: lastInstructionMemoryAddress + 7) equals: (jumpMemoryAddress & 16r00FF00) >> 8.
	self assert: (assembly memoryAt: lastInstructionMemoryAddress + 8) equals: (jumpMemoryAddress & 16r0000FF).
	
	
]
