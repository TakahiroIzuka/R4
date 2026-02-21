import ErrorMessage from '@/components/ErrorMessage'
import { notFound } from 'next/navigation'
import HomeClient from '@/components/HomeClient'
import { fetchFacilitiesByGenre, fetchGenreById, fetchFacilitiesImages } from '@/lib/data/facilities'

interface GenrePageProps {
  params: Promise<{
    serviceCode: string
    id: string
  }>
}

export default async function GenrePage({ params }: GenrePageProps) {
  const { serviceCode, id } = await params

  // Get genre information
  const { genre, error: genreError } = await fetchGenreById(id)

  if (genreError || !genre) {
    notFound()
  }

  // Get facilities filtered by genre_id
  const { facilities, error } = await fetchFacilitiesByGenre(id, serviceCode)

  if (error) {
    return <ErrorMessage message={error.message} />
  }

  // Fetch images for all facilities
  const facilityIds = facilities?.map(f => f.id) || []
  const { imagesMap } = await fetchFacilitiesImages(facilityIds)

  return (
    <HomeClient
      facilities={facilities || []}
      genreId={genre.id}
      genreName={genre.name}
      genreCode={genre.code}
      imagesMap={imagesMap}
    />
  )
}
