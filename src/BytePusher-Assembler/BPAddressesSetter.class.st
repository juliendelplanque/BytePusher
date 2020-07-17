"
I do a pass on the list of instructions to resolve and sets their address in memory.
That is to say, for each instruction to resolve, I set the address it will have in the memory of the virtual machine.

I implement the 1st step to achieve when assembling the assembler code.
"
Class {
	#name : #BPAddressesSetter,
	#superclass : #BPAssemblerVisitor,
	#instVars : [
		'currentAddress'
	],
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Assembler-Visitors'
}

{ #category : #accessing }
BPAddressesSetter >> currentAddress [
	^ currentAddress
]

{ #category : #private }
BPAddressesSetter >> incrementCurrentAddress: numberOfBytes [
	currentAddress := currentAddress + numberOfBytes
]

{ #category : #visiting }
BPAddressesSetter >> visitBPAddress: aBPAddress [
	self error: 'There should be no BPAddress reached at this step.'
]

{ #category : #visiting }
BPAddressesSetter >> visitBPAddressDataAccess: aBPAddressDataAccess [
	self error: 'There should be no BPAddressDataAccess reached at this step.'
]

{ #category : #visiting }
BPAddressesSetter >> visitBPAddressDataReference: aBPAddressDataReference [
	self error: 'There should be no BPAddressDataReference reached at this step.'
]

{ #category : #visiting }
BPAddressesSetter >> visitBPAssembler: aBPAssembler [
	super visitBPAssembler: aBPAssembler.
	currentAddress := self memoryLayout firstGenerationAddress.
	aBPAssembler instructions do: [ :instructionToResolve |
		self visit: instructionToResolve ]
]

{ #category : #visiting }
BPAddressesSetter >> visitBPDataToResolve: aBPDataToResolve [
	aBPDataToResolve address: self currentAddress.
	self incrementCurrentAddress: aBPDataToResolve spaceInMemoryRequired
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

{ #category : #visiting }
BPAddressesSetter >> visitBPLabelReference: aBPLabelReference [
	self error: 'There should be no BPLabelReference reached at this step.'
]

{ #category : #visiting }
BPAddressesSetter >> visitBPNextInstructionReference: aBPNextInstructionReference [
	self error: 'There should be no BPNextInstructionReference reached at this step.'
]

{ #category : #visiting }
BPAddressesSetter >> visitBPOffsetReference: aBPOffsetReference [
	self error: 'There should be no BPOffsetReference reached at this step.'
]

{ #category : #visiting }
BPAddressesSetter >> visitBPReferenceToInstruction: aBPReferenceToInstruction [
	self error: 'There should be no BPReferenceToInstruction reached at this step.'
]

{ #category : #visiting }
BPAddressesSetter >> visitBPRegister: aBPRegister [
	self error: 'There should be no BPRegister reached at this step.'
]

{ #category : #visiting }
BPAddressesSetter >> visitBPReservedMemoryZone: aBPReservedMemoryZone [
	self error: 'There should be no BPReservedMemoryZone reached at this step.'
]
