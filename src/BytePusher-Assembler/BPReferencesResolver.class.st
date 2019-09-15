Class {
	#name : #BPReferencesResolver,
	#superclass : #BPAssemblerVisitor,
	#category : #'BytePusher-Assembler'
}

{ #category : #visiting }
BPReferencesResolver >> visitBPAddress: aBPAddress [
	^ aBPAddress
]

{ #category : #visiting }
BPReferencesResolver >> visitBPAddressDataReference: aBPAddressDataReference [ 
	self shouldBeImplemented.
]

{ #category : #visiting }
BPReferencesResolver >> visitBPAssembler: aBPAssembler [
	| assembled |
	assembled := BPAssembledCode new.
	assembled memoryLayout: aBPAssembler memoryLayout.
	aBPAssembler instructions do: [ :instructionToResolve |
		(self visit: instructionToResolve)
			beAssembledIn: assembled ].
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
BPReferencesResolver >> visitBPLabel: aBPLabel [
	^ aBPLabel
]

{ #category : #visiting }
BPReferencesResolver >> visitBPNextInstructionReference: aBPNextInstructionReference [
	self error: 'There should be no more BPNextInstructionReference to resolve at this step.'
]

{ #category : #visiting }
BPReferencesResolver >> visitBPOffsetReference: aBPOffsetReference [
	^ (self visit: aBPOffsetReference objectWithAddress) + aBPOffsetReference offset
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
