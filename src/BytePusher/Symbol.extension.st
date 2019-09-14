Extension { #name : #Symbol }

{ #category : #'*BytePusher' }
Symbol >> forAssembler: anAssembly [
	^ [ anAssembly registerNamed: self ]
		on: NotFound
		do: [ |label|
			label := BPLabel label: self.
			anAssembly addInstruction: label.
			label ]
]

{ #category : #'*BytePusher' }
Symbol >> forAssembly: anAssembly [
	^ [ anAssembly registerNamed: self ]
		on: NotFound
		do: [ ^ anAssembly labelNamed: self ]
]
