Extension { #name : #Integer }

{ #category : #'*BytePusher' }
Integer >> asBPAddress [
	^ BPAddress memoryAddress: self
]

{ #category : #'*BytePusher' }
Integer >> forAssembly: anAssembly [
	anAssembly memoryAt: anAssembly lastBPInstructionIndex memoryAddress put: self.
	anAssembly lastBPInstructionIndex: anAssembly lastBPInstructionIndex + 1.
	^ anAssembly lastBPInstructionIndex - 1
]
