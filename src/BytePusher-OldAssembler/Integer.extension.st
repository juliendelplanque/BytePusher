Extension { #name : #Integer }

{ #category : #'*BytePusher-OldAssembler' }
Integer >> forAssembly: anAssembly [
	anAssembly memoryAt: anAssembly addressOfNextInstructionToGenerate memoryAddress put: self.
	anAssembly labels
		select: [ :label | label address = anAssembly addressOfNextInstructionToGenerate ]
		thenDo: [ :label | label address: label address + 1 ].
	anAssembly addressOfNextInstructionToGenerate: anAssembly addressOfNextInstructionToGenerate + 1.
	anAssembly incrementReferencesToFutureMemory: 1.
	^ anAssembly addressOfNextInstructionToGenerate - 1
]
