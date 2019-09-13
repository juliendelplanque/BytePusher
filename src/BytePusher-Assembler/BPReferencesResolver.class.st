Class {
	#name : #BPReferencesResolver,
	#superclass : #BPAssemblerVisitor,
	#instVars : [
		'currentInstructionIndex',
		'assembler'
	],
	#category : #'BytePusher-Assembler'
}

{ #category : #visiting }
BPReferencesResolver >> visitBPAddress: aBPAddress [
	^ aBPAddress
]

{ #category : #visiting }
BPReferencesResolver >> visitBPAssembler: aBPAssembler [
	| assembled |
	assembler := aBPAssembler.
	assembled := BPAssembledCode new.
	assembled memoryLayout: aBPAssembler memoryLayout.
	aBPAssembler instructions doWithIndex: [ :instructionToResolve :index |
		currentInstructionIndex := index.
		assembled addInstruction: (self visit: instructionToResolve) ].
	^ assembled
]

{ #category : #visiting }
BPReferencesResolver >> visitBPData: aBPData [
	^ aBPData
]

{ #category : #visiting }
BPReferencesResolver >> visitBPDataReference: aBPDataReference [
	^ aBPDataReference data address
]

{ #category : #visiting }
BPReferencesResolver >> visitBPInstructionToResolve: aBPInstructionToResolve [
	^ BPInstruction
		address: aBPInstructionToResolve address
		from: (self visit: aBPInstructionToResolve from)
		to: (self visit: aBPInstructionToResolve to)
		jump: (self visit: aBPInstructionToResolve jump)
]

{ #category : #visiting }
BPReferencesResolver >> visitBPNextInstructionReference: aBPNextInstructionReference [
	^ [
		((assembler instructions copyFrom: currentInstructionIndex + 1 to: assembler instructions size)
			detect: #isInstructionToResolve) address
	] on: NotFound do: [ 
		self flag: #TODO. "Manage correctly the last instruction jump."
		0 asBPAddress ]
]

{ #category : #visiting }
BPReferencesResolver >> visitBPReferenceToInstruction: aBPReferenceToInstruction [
	^ aBPReferenceToInstruction instruction address + aBPReferenceToInstruction byteIndex
]

{ #category : #visiting }
BPReferencesResolver >> visitBPRegister: aBPRegister [
	^ aBPRegister address
]

{ #category : #visiting }
BPReferencesResolver >> visitBPReservedMemoryZone: aBPReservedMemoryZone [
	^ aBPReservedMemoryZone address
]
