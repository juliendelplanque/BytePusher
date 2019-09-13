Extension { #name : #Symbol }

{ #category : #'*BytePusher' }
Symbol >> forAssembler: anAssembly [
	^ [ anAssembly registerNamed: self ]
		on: NotFound
		do: [ self error: 'Should create label declaration.' ]
]

{ #category : #'*BytePusher' }
Symbol >> forAssembly: anAssembly [
	^ [ anAssembly registerNamed: self ]
		on: NotFound
		do: [ ^ anAssembly labelNamed: self ]
]
