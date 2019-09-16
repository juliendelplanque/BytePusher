Class {
	#name : #BPAddressesSetter,
	#superclass : #BPAssemblerVisitor,
	#instVars : [
		'currentAddress'
	],
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Assembler'
}

{ #category : #accessing }
BPAddressesSetter >> currentAddress [
	^ currentAddress
]

{ #category : #private }
BPAddressesSetter >> incrementCurrentAddress: numberOfBytes [
	currentAddress := currentAddress + numberOfBytes
]

{ #category : #initialization }
BPAddressesSetter >> initialize [
	super initialize.
	currentAddress := self memoryLayout firstGenerationAddress.
]

{ #category : #visiting }
BPAddressesSetter >> visitBPAssembler: aBPAssembler [
	aBPAssembler instructions do: [ :instructionToResolve |
		self visit: instructionToResolve ]
]

{ #category : #visiting }
BPAddressesSetter >> visitBPInstructionToResolve: aBPInstructionToResolve [
	aBPInstructionToResolve address: self currentAddress.
	self incrementCurrentAddress: INSTRUCTION_SIZE
]

{ #category : #visiting }
BPAddressesSetter >> visitBPLabel: aBPLabel [
	"Do nothing here, will be processed in next step."
]
