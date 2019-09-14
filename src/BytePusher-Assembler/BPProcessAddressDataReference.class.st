Class {
	#name : #BPProcessAddressDataReference,
	#superclass : #BPAssemblerVisitor,
	#instVars : [
		'currentInstructionIndex',
		'assembler'
	],
	#category : #'BytePusher-Assembler'
}

{ #category : #visiting }
BPProcessAddressDataReference >> visitBPAddress: aBPAddress [ 
	^ aBPAddress
]

{ #category : #visiting }
BPProcessAddressDataReference >> visitBPAddressDataReference: aBPAddressDataReference [ 
	| address data |
	address := aBPAddressDataReference address.
	address class = BPLabel
		ifTrue: [ address := address address ].
	address class = BPReferenceToInstruction
		ifTrue: [ address := address instruction address ].
		
	data := BPData byte: (address byteAt: aBPAddressDataReference byteIndex).
	assembler instructions add: data before: (assembler instructions at: currentInstructionIndex).
	data address: (assembler instructions at: currentInstructionIndex + 1) address.
	currentInstructionIndex to: assembler instructions size do: [ :i |
		(assembler instructions at: i) address: (assembler instructions at: i) address + 1 ].
	^ data asReference
]

{ #category : #visiting }
BPProcessAddressDataReference >> visitBPAssembler: aBPAssembler [
	assembler := aBPAssembler.
	aBPAssembler instructions copy doWithIndex: [ :instructionToResolve :index |
		currentInstructionIndex := index.
		self visit: instructionToResolve ]
]

{ #category : #visiting }
BPProcessAddressDataReference >> visitBPData: aBPData [ 
	^ aBPData
]

{ #category : #visiting }
BPProcessAddressDataReference >> visitBPDataReference: aBPDataReference [ 
	^ aBPDataReference
]

{ #category : #visiting }
BPProcessAddressDataReference >> visitBPInstructionToResolve: aBPInstructionToResolve [ 
	^ aBPInstructionToResolve
		from: (self visit: aBPInstructionToResolve from);
		to: (self visit: aBPInstructionToResolve to);
		jump: (self visit: aBPInstructionToResolve jump);
		yourself
]

{ #category : #visiting }
BPProcessAddressDataReference >> visitBPLabel: aBPLabel [ 
	^ aBPLabel
]

{ #category : #visiting }
BPProcessAddressDataReference >> visitBPOffsetReference: aBPOffsetReference [ 
	"Do nothing here, will be resolved later."
	^ aBPOffsetReference
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
