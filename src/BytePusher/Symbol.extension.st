Extension { #name : #Symbol }

{ #category : #'*BytePusher' }
Symbol >> forAssembly: anAssembly [
	^ [ anAssembly registerNamed: self ]
		on: NotFound
		do: [ ^ anAssembly labelNamed: self ]
]
