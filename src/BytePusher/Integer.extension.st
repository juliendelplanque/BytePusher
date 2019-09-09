Extension { #name : #Integer }

{ #category : #'*BytePusher' }
Integer >> asBPAddress [
	^ BPAddress memoryAddress: self
]

{ #category : #'*BytePusher' }
Integer >> forAssembly: anAssembly [
	anAssembly memoryAt: anAssembly addressOfNextInstructionToGenerate memoryAddress put: self.
	anAssembly addressOfNextInstructionToGenerate: anAssembly addressOfNextInstructionToGenerate + 1.
	^ anAssembly addressOfNextInstructionToGenerate - 1
]
