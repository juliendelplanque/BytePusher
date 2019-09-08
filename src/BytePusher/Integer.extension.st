Extension { #name : #Integer }

{ #category : #'*BytePusher' }
Integer >> asBPAddress [
	^ BPAddress memoryAddress: self
]
