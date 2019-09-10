Class {
	#name : #BPAddCarryFlagPageBuilder,
	#superclass : #BPOpcodeBankBuilder,
	#category : #'BytePusher-Assembly'
}

{ #category : #accessing }
BPAddCarryFlagPageBuilder class >> endAddress [
	^ 16rE20000 asBPAddress - 1
]

{ #category : #accessing }
BPAddCarryFlagPageBuilder class >> reservedMemoryZone [
	^ super reservedMemoryZone
		name: #ADD_CARY_FLAG_PAGE;
		yourself
]

{ #category : #accessing }
BPAddCarryFlagPageBuilder class >> startAddress [
	^ 16rE10000 asBPAddress
]

{ #category : #writing }
BPAddCarryFlagPageBuilder >> writeBankOn: aByteArray [
	self addressesRange do: [ :address | 
		| x y |
		x := (address & 16rFF00) >> 8.
		y := address & 16rFF.
		aByteArray
			at: address + 1 "In byte pusher, addressing starts at 0, in Pharo it starts at 1."
			put: ((x + y) // 16rFF > 0) asBit	 ]
]
