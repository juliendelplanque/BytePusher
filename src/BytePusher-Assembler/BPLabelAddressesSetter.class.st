Class {
	#name : #BPLabelAddressesSetter,
	#superclass : #BPAssemblerVisitor,
	#instVars : [
		'assembler'
	],
	#category : #'BytePusher-Assembler-Visitors'
}

{ #category : #visiting }
BPLabelAddressesSetter >> visitBPAddress: aBPAddress [
	self error: 'There should be no BPAddress reached at this step.'
]

{ #category : #visiting }
BPLabelAddressesSetter >> visitBPAddressDataAccess: aBPAddressDataAccess [
	self error: 'There should be no BPAddressDataAccess reached at this step.'
]

{ #category : #visiting }
BPLabelAddressesSetter >> visitBPAddressDataReference: aBPAddressDataReference [
	self error: 'There should be no BPAddressDataReference reached at this step.'
]

{ #category : #visiting }
BPLabelAddressesSetter >> visitBPAssembler: aBPAssembler [
	super visitBPAssembler: aBPAssembler.
	assembler := aBPAssembler.
	aBPAssembler instructions do: [ :instructionToResolve |
		self visit: instructionToResolve ]
]

{ #category : #visiting }
BPLabelAddressesSetter >> visitBPInstructionToResolve: aBPInstructionToResolve [
	^ aBPInstructionToResolve
]

{ #category : #visiting }
BPLabelAddressesSetter >> visitBPLabel: aBPLabel [
	| start |
	start := assembler instructions indexOf: aBPLabel.
	
	assembler instructions from: start to: assembler instructions size do: [ :inst |
		inst class = BPInstructionToResolve
			ifTrue: [ aBPLabel address: inst address. ^ aBPLabel ] ].
		
	self error: 'Should not reach this point.'
]

{ #category : #visiting }
BPLabelAddressesSetter >> visitBPLabelReference: aBPLabelReference [
	self error: 'There should be no BPLabelReference reached at this step.'
]

{ #category : #visiting }
BPLabelAddressesSetter >> visitBPNextInstructionReference: aBPNextInstructionReference [
	self error: 'There should be no BPNextInstructionReference reached at this step.'
]

{ #category : #visiting }
BPLabelAddressesSetter >> visitBPOffsetReference: aBPOffsetReference [
	self error: 'There should be no BPOffsetReference reached at this step.'
]

{ #category : #visiting }
BPLabelAddressesSetter >> visitBPReferenceToInstruction: aBPReferenceToInstruction [
	self error: 'There should be no BPReferenceToInstruction reached at this step.'
]

{ #category : #visiting }
BPLabelAddressesSetter >> visitBPRegister: aBPRegister [
	self error: 'There should be no BPRegister reached at this step.'
]

{ #category : #visiting }
BPLabelAddressesSetter >> visitBPReservedMemoryZone: aBPReservedMemoryZone [
	self error: 'There should be no BPReservedMemoryZone reached at this step.'
]
