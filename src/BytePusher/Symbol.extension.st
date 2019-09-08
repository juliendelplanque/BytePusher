Extension { #name : #Symbol }

{ #category : #'*BytePusher' }
Symbol >> forAssembly: anAssembly [
	^ anAssembly registerNamed: self
]
