Class {
	#name : #BPAddZeroFlagPageBuilder,
	#superclass : #BPOpcodeBankBuilder,
	#category : #'BytePusher-Assembly'
}

{ #category : #accessing }
BPAddZeroFlagPageBuilder class >> endAddress [
	^ 16rE30000 asBPAddress - 1
]

{ #category : #accessing }
BPAddZeroFlagPageBuilder class >> reservedMemoryZone [
	^ super reservedMemoryZone
		name: #ADD_ZERO_FLAG_PAGE;
		yourself
]

{ #category : #accessing }
BPAddZeroFlagPageBuilder class >> startAddress [
	^ 16rE20000 asBPAddress
]

{ #category : #writing }
BPAddZeroFlagPageBuilder >> writeBankOn: aByteArray [
	self addressesRange do: [ :address | 
		| x y |
		x := (address & 16rFF00) >> 8.
		y := address & 16rFF.
		aByteArray
			at: address + 1 "In byte pusher, addressing starts at 0, in Pharo it starts at 1."
			put: (((x + y) % 16rFF = 0) ifTrue: [ 0 ] ifFalse: [ 3 ])	 ]
]
