Class {
	#name : #BPProcessAddressDataReference,
	#superclass : #BPAssemblerVisitor,
	#instVars : [
		'currentInstructionIndex',
		'assembler'
	],
	#category : #'BytePusher-Assembler-Visitors'
}

{ #category : #visiting }
BPProcessAddressDataReference >> visit: anObject [
	anObject isInteger
		ifTrue: [ ^ anObject ].
	^ super visit: anObject
]

{ #category : #visiting }
BPProcessAddressDataReference >> visitBPAddress: aBPAddress [ 
	^ aBPAddress
]

{ #category : #visiting }
BPProcessAddressDataReference >> visitBPAddressDataAccess: aBPAddressDataAccess [
	^ aBPAddressDataAccess objectWithAddress address
		byteAt: aBPAddressDataAccess offset
]

{ #category : #visiting }
BPProcessAddressDataReference >> visitBPAddressDataReference: aBPAddressDataReference [ 
	| address |
	address := aBPAddressDataReference address.
	
	^ (self memoryLayout reservedMemoryZoneNamed: #IDENTITY_PAGE) address
		+ (address byteAt: aBPAddressDataReference offset)
]

{ #category : #visiting }
BPProcessAddressDataReference >> visitBPAssembler: aBPAssembler [
	super visitBPAssembler: aBPAssembler.
	assembler := aBPAssembler.
	aBPAssembler instructions copy doWithIndex: [ :instructionToResolve :index |
		currentInstructionIndex := index.
		self visit: instructionToResolve ]
]

{ #category : #visiting }
BPProcessAddressDataReference >> visitBPInstructionToResolve: aBPInstructionToResolve [ 
	^ aBPInstructionToResolve
		from: (self visit: aBPInstructionToResolve from);
		to: (self visit: aBPInstructionToResolve to);
		jump: (self visit: aBPInstructionToResolve jump);
		address
]

{ #category : #visiting }
BPProcessAddressDataReference >> visitBPLabel: aBPLabel [ 
	^ aBPLabel
]

{ #category : #visiting }
BPProcessAddressDataReference >> visitBPOffsetReference: aBPOffsetReference [ 
	^ aBPOffsetReference
		objectWithAddress: (self visit: aBPOffsetReference objectWithAddress);
		offset: (self visit: aBPOffsetReference offset);
		yourself
]

{ #category : #visiting }
BPProcessAddressDataReference >> visitBPReferenceToInstruction: aBPReferenceToInstruction [ 
	"Do not visit the instruction, else it creates an infinite loop!"
	^ aBPReferenceToInstruction
]

{ #category : #visiting }
BPProcessAddressDataReference >> visitBPRegister: aBPRegister [ 
	^ aBPRegister
]

{ #category : #visiting }
BPProcessAddressDataReference >> visitBPReservedMemoryZone: aBPReservedMemoryZone [ 
	^ aBPReservedMemoryZone
]
