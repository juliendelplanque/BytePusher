Extension { #name : #Integer }

{ #category : #'*BytePusher' }
Integer >> asBPAddress [
	^ BPAddress memoryAddress: self
]

{ #category : #'*BytePusher' }
Integer >> forAssembly: anAssembly [
	| shouldSerialize |
	shouldSerialize := anAssembly hasMemoryBeenWritten not.
	anAssembly memoryAt: anAssembly addressOfNextInstructionToGenerate memoryAddress put: self.
	anAssembly addressOfNextInstructionToGenerate: anAssembly addressOfNextInstructionToGenerate + 1.
	shouldSerialize ifTrue: [ anAssembly serializeAddressOfNextInstructionToGenerate ].
	^ anAssembly addressOfNextInstructionToGenerate - 1
]
