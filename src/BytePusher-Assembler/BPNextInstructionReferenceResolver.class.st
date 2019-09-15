Class {
	#name : #BPNextInstructionReferenceResolver,
	#superclass : #BPAssemblerVisitor,
	#instVars : [
		'assembler',
		'currentInstructionIndex'
	],
	#category : #'BytePusher-Assembler'
}

{ #category : #visiting }
BPNextInstructionReferenceResolver >> visitBPAddress: aBPAddress [ 
	^ aBPAddress
]

{ #category : #visiting }
BPNextInstructionReferenceResolver >> visitBPAddressDataReference: aBPAddressDataReference [ 
	^ aBPAddressDataReference
		address: (self visit: aBPAddressDataReference address);
		yourself
]

{ #category : #visiting }
BPNextInstructionReferenceResolver >> visitBPAssembler: aBPAssembler [
	assembler := aBPAssembler.
	aBPAssembler instructions copy doWithIndex: [ :instructionToResolve :index |
		currentInstructionIndex := index.
		self visit: instructionToResolve ]
]

{ #category : #visiting }
BPNextInstructionReferenceResolver >> visitBPData: aBPData [ 
	^ aBPData
]

{ #category : #visiting }
BPNextInstructionReferenceResolver >> visitBPDataReference: aBPDataReference [ 
	^ aBPDataReference
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
	^ assembler instructions detect: [ :instruction | instruction class = BPLabel and: [ instruction label = aBPLabelReference label ] ]
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
	self flag: #TODO. "Manage correctly the last instruction jump."
	^ 0 asBPAddress
]

{ #category : #visiting }
BPNextInstructionReferenceResolver >> visitBPOffsetReference: aBPOffsetReference [ 
	^ aBPOffsetReference
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
