Class {
	#name : #BPNextInstructionReferenceResolver,
	#superclass : #BPAssemblerVisitor,
	#instVars : [
		'assembler',
		'currentInstructionIndex'
	],
	#category : #'BytePusher-Assembler-Visitors'
}

{ #category : #visiting }
BPNextInstructionReferenceResolver >> visit: anObject [
	anObject isInteger
		ifTrue: [ ^ anObject ].
	anObject class = ByteArray
		ifTrue: [ ^ anObject ].
	^ super visit: anObject
]

{ #category : #visiting }
BPNextInstructionReferenceResolver >> visitBPAddress: aBPAddress [ 
	^ aBPAddress
]

{ #category : #visiting }
BPNextInstructionReferenceResolver >> visitBPAddressDataAccess: aBPAddressDataAccess [
	^ aBPAddressDataAccess
		objectWithAddress: (self visit: aBPAddressDataAccess objectWithAddress);
		yourself
]

{ #category : #visiting }
BPNextInstructionReferenceResolver >> visitBPAddressDataReference: aBPAddressDataReference [ 
	^ aBPAddressDataReference
		objectWithAddress: (self visit: aBPAddressDataReference objectWithAddress);
		yourself
]

{ #category : #visiting }
BPNextInstructionReferenceResolver >> visitBPAssembler: aBPAssembler [
	super visitBPAssembler: aBPAssembler.
	assembler := aBPAssembler.
	aBPAssembler instructions copy doWithIndex: [ :instructionToResolve :index |
		currentInstructionIndex := index.
		self visit: instructionToResolve ]
]

{ #category : #visiting }
BPNextInstructionReferenceResolver >> visitBPDataToResolve: aBPDataToResolve [
	^ aBPDataToResolve
		data: (self visit: aBPDataToResolve data);
		yourself
]

{ #category : #visiting }
BPNextInstructionReferenceResolver >> visitBPInstructionToResolve: aBPInstructionToResolve [ 
	^ aBPInstructionToResolve
		from: (self visit: aBPInstructionToResolve from);
		to: (self visit: aBPInstructionToResolve to);
		jump: (self visit: aBPInstructionToResolve jump);
		yourself
]

{ #category : #visiting }
BPNextInstructionReferenceResolver >> visitBPLabel: aBPLabel [ 
	^ aBPLabel
]

{ #category : #visiting }
BPNextInstructionReferenceResolver >> visitBPLabelReference: aBPLabelReference [
	| label |
	label := assembler instructions detect: [ :instruction | instruction class = BPLabel and: [ instruction label = aBPLabelReference label ] ].
	
	aBPLabelReference hasOffset
		ifFalse: [ ^ label ].
		
	^ BPMemoryReference new
		offset: aBPLabelReference offset;
		objectWithAddress: label;
		yourself
]

{ #category : #visiting }
BPNextInstructionReferenceResolver >> visitBPNextInstructionReference: aBPNextInstructionReference [
	|offset|
	offset := aBPNextInstructionReference offset.
	currentInstructionIndex + 1 to: assembler instructions size do: [ :i |
		|instruction|
		instruction := assembler instructions at: i.
		instruction isInstructionToResolve
			ifTrue: [ 
				offset = 0
					ifTrue: [ ^ instruction asReference ]
					ifFalse: [ offset := offset - 1 ] ] ].
	
	^ (self memoryLayout reservedMemoryZoneNamed: #INFINITE_NOP) startAddress
]

{ #category : #visiting }
BPNextInstructionReferenceResolver >> visitBPOffsetReference: aBPOffsetReference [ 
	^ aBPOffsetReference
		objectWithAddress: (self visit: aBPOffsetReference objectWithAddress);
		offset: (self visit: aBPOffsetReference offset);
		yourself
]

{ #category : #visiting }
BPNextInstructionReferenceResolver >> visitBPReferenceToInstruction: aBPReferenceToInstruction [ 
	^ aBPReferenceToInstruction
]

{ #category : #visiting }
BPNextInstructionReferenceResolver >> visitBPRegister: aBPRegister [ 
	^ aBPRegister
]

{ #category : #visiting }
BPNextInstructionReferenceResolver >> visitBPReservedMemoryZone: aBPReservedMemoryZone [ 
	^ aBPReservedMemoryZone
]
