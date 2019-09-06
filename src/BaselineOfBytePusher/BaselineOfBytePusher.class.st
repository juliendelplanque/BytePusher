Class {
	#name : #BaselineOfBytePusher,
	#superclass : #BaselineOf,
	#category : #BaselineOfBytePusher
}

{ #category : #baselines }
BaselineOfBytePusher >> baseline: spec [
	<baseline>
	spec for: #common do: [ 
		spec package: 'BytePusher' ]
]
