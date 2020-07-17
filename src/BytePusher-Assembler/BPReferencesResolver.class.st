Class {
	#name : #BPReferencesResolver,
	#superclass : #BPAssemblerVisitor,
	#category : #'BytePusher-Assembler-Visitors'
}

{ #category : #visiting }
BPReferencesResolver >> visit: anObject [
	anObject isInteger
		ifTrue: [ ^ anObject ].
	anObject class = ByteArray
		ifTrue: [ ^ anObject ].
	^ super visit: anObject
]

{ #category : #visiting }
BPReferencesResolver >> visitBPAddress: aBPAddress [
	^ aBPAddress
]

{ #category : #visiting }
BPReferencesResolver >> visitBPAssembler: aBPAssembler [
	| assembled |
	super visitBPAssembler: aBPAssembler.
	assembled := BPAssembledCode new.
	assembled memoryLayout: aBPAssembler memoryLayout.
	aBPAssembler instructions do: [ :instructionToResolve |
		instructionToResolve class = BPLabel
			ifTrue: [ instructionToResolve beAssembledIn: assembled ]
			ifFalse: [ 
				(self visit: instructionToResolve)
					beAssembledIn: assembled ] ].
	^ assembled
]

{ #category : #visiting }
BPReferencesResolver >> visitBPDataToResolve: aBPDataToResolve [
	^ BPData new
		address: aBPDataToResolve address;
		data: (self visit: aBPDataToResolve data);
		assemblerInstruction: aBPDataToResolve assemblerInstruction;
		yourself
]

{ #category : #visiting }
BPReferencesResolver >> visitBPInstructionToResolve: aBPInstructionToResolve [
	^ BPInstruction new
		address: aBPInstructionToResolve address;
		fromAddress: (self visit: aBPInstructionToResolve from);
		toAddress: (self visit: aBPInstructionToResolve to);
		jumpAddress: (self visit: aBPInstructionToResolve jump);
		assemblerInstruction: aBPInstructionToResolve assemblerInstruction;
		yourself
]

{ #category : #visiting }
BPReferencesResolver >> visitBPLabel: aBPLabel [
	^ aBPLabel address 
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
	^ aBPReferenceToInstruction instruction address + aBPReferenceToInstruction offset
]

{ #category : #visiting }
BPReferencesResolver >> visitBPRegister: aBPRegister [
	^ aBPRegister address
]

{ #category : #visiting }
BPReferencesResolver >> visitBPReservedMemoryZone: aBPReservedMemoryZone [
	^ aBPReservedMemoryZone address
]
