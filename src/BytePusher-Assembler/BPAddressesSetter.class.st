Class {
	#name : #BPAddressesSetter,
	#superclass : #BPAssemblerVisitor,
	#instVars : [
		'memoryLayout',
		'currentAddress'
	],
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Assembler'
}

{ #category : #accessing }
BPAddressesSetter class >> defaultMemoryLayout [
	^ BPMemoryLayout standard
]

{ #category : #accessing }
BPAddressesSetter >> currentAddress [
	^ currentAddress
]

{ #category : #accessing }
BPAddressesSetter >> defaultMemoryLayout [
	^ self class defaultMemoryLayout
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

{ #category : #accessing }
BPAddressesSetter >> memoryLayout [
	^ memoryLayout ifNil: [ memoryLayout := self defaultMemoryLayout ]
]

{ #category : #accessing }
BPAddressesSetter >> memoryLayout: anObject [
	memoryLayout := anObject
]

{ #category : #visiting }
BPAddressesSetter >> visitBPAssembler: aBPAssembler [
	aBPAssembler instructions do: [ :instructionToResolve |
		self visit: instructionToResolve ]
]

{ #category : #visiting }
BPAddressesSetter >> visitBPData: aBPData [
	aBPData address: self currentAddress.
	self incrementCurrentAddress: 1
]

{ #category : #visiting }
BPAddressesSetter >> visitBPInstructionToResolve: aBPInstructionToResolve [
	aBPInstructionToResolve address: self currentAddress.
	self incrementCurrentAddress: INSTRUCTION_SIZE
]
